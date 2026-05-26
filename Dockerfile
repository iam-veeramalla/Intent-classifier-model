# Use a slim official Python image
FROM python:3.10-slim

# Prevent Python from writing .pyc files and enable stdout/stderr flushing
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps (if needed) and Python deps
COPY requirements.txt .
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc libc-dev \
 && pip install --no-cache-dir -r requirements.txt \
 && apt-get remove -y gcc libc-dev \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Copy app code and model file(s)
COPY . .

# Train the Model
RUN python3 model/train.py

# Expose the port your app runs on
EXPOSE 6000

# Start the app with gunicorn (4 workers, bind to 0.0.0.0:6000)
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:6000", "app:app"]

## Start the app with Gunicorn managing 4 Uvicorn ASGI workers, bound to port 6000
# CMD ["gunicorn", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:6000", "app:app"]
