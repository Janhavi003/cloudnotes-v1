# 4.2 Feedback Fix

The Kubernetes grader identified an application binding issue. The corrected project explicitly binds Flask to `0.0.0.0` on port `5000` so traffic from the Pod network, Kubernetes Service, and health probes can reach the application.

The deployment now uses the new image tag `localhost:5000/cloudnotes:1.0.1` rather than the older `1.0.0` tag. This avoids accidentally running a stale locally cached image.

The application also exposes `/health`, and the Deployment readiness and liveness probes check that endpoint.

## Rebuild the corrected image

```bash
docker build -t localhost:5000/cloudnotes:1.0.1 .
docker push localhost:5000/cloudnotes:1.0.1
```

If using Minikube and the local registry is not reachable from the cluster, load the corrected image into Minikube and use an image reference appropriate to that cluster. The important requirement is that the Deployment runs the corrected image.

## Verify

```bash
kubectl apply -f k8s/
kubectl rollout status deployment/cloudnotes
kubectl get pods
kubectl get endpoints cloudnotes
kubectl port-forward svc/cloudnotes 8080:80
curl -i http://localhost:8080/
```

The application should be ready and return HTTP 200. Do not claim these runtime results until they have actually been observed on the local cluster.

## Data consistency

The current CloudNotes SQLite database and uploads directory are Pod-local. Multiple replicas therefore do not provide shared persistence. For a production design, use a managed/shared database and object storage or a suitable shared persistent-volume architecture.
