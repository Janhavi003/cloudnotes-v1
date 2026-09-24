# Kubernetes 4.2 Feedback Fix

The previous grader feedback identified an application binding problem. This corrected project addresses it in `app.py`: Flask listens on `0.0.0.0:5000` so Kubernetes probes and Service traffic can reach the application through the Pod network.

A `/health` endpoint returns HTTP 200, and both readiness and liveness probes use that endpoint. The Deployment uses the corrected `cloudnotes:1.0.1` image and is configured for a three-replica RollingUpdate.

For a local Minikube cluster without Docker Desktop, build the image directly inside Minikube:

```powershell
minikube image build -t cloudnotes:1.0.1 .
```

Then apply:

```powershell
kubectl apply -f k8s/
kubectl rollout status deployment/cloudnotes
kubectl get pods
kubectl get endpoints cloudnotes
```

Finally:

```powershell
kubectl port-forward svc/cloudnotes 8080:80
curl -i http://localhost:8080/
```

Do not claim runtime results in the submission until they have actually been observed on the local cluster.

## Data consistency

The current SQLite database and uploads directory are Pod-local. A production multi-replica deployment should use a shared/managed database and object storage or another appropriate persistent storage architecture. This is a documented production improvement and is not required for the 4.2 local-cluster task.
