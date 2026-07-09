# Kserve Demonstration for Iris model

### Install Cert Manager

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```

### Install KServe CRDs

```
kubectl create namespace kserve

helm install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd \
  --version v0.16.0 \
  -n kserve \
  --wait
```

### Install KServe controller

```
helm install kserve oci://ghcr.io/kserve/charts/kserve \
  --version v0.16.0 \
  -n kserve \
  --set kserve.controller.deploymentMode=RawDeployment \
  --wait
```

### Deploy the Intent Classifier model

```
kubectl create namespace intent

cat <<EOF | kubectl apply -n intent -f -
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: intent-classifier
spec:
  predictor:
    containers:
      - name: kserve-container
        image: kserve/sklearnserver:v0.11.0
        args:
          - "--model_dir=/mnt/models"
          - "--model_name=intent-classifier"
        resources:
          requests:
            cpu: "100m"
            memory: "512Mi"
          limits:
            cpu: "1"
            memory: "1Gi"
        env:
          - name: STORAGE_URI
            value: "<downloadable location>"
EOF

kubectl get inferenceservice intent-classifier -n intent
```

### Port-forward to access the model

```
kubectl -n ml port-forward svc/<svc-name> 8080:80
```

### Inference the Model

```
curl -s -X POST http://localhost:8080/v1/models/intent-classifier:predict \
  -H "Content-Type: application/json" \
  -d '{"instances":["I want to cancel my subscription"]}' | jq
```


