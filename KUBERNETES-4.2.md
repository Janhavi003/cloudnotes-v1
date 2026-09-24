# CloudNotes Kubernetes 4.2

This project contains the Kubernetes Deployment and Service required for assignment 4.2. The manifests are designed to work with a local Minikube cluster without requiring Docker Desktop.

## Application configuration

CloudNotes listens on container port `5000` and Flask explicitly binds to `0.0.0.0`, not `127.0.0.1`. The application exposes `/health`, which returns HTTP 200 and is used by the Kubernetes readiness and liveness probes.

## Minikube workflow (no Docker Desktop required)

1. Start Minikube with an available driver, for example Hyper-V on Windows:

```powershell
minikube start --driver=hyperv
```

2. Verify the node is Ready:

```powershell
kubectl get nodes
```

3. Build the image directly inside Minikube:

```powershell
minikube image build -t cloudnotes:1.0.1 .
```

4. Confirm the image is present:

```powershell
minikube image ls | Select-String cloudnotes
```

5. Apply the manifests:

```powershell
kubectl apply -f k8s/
kubectl rollout status deployment/cloudnotes
```

6. Verify the Pods and Service:

```powershell
kubectl get pods
kubectl get svc cloudnotes
kubectl get endpoints cloudnotes
```

All three Pods should become `1/1 Running`. The endpoints output should contain Pod IP addresses and port 5000, not `<none>`.

7. Expose the Service locally:

```powershell
kubectl port-forward svc/cloudnotes 8080:80
```

In another terminal or in a browser, verify:

```text
http://localhost:8080/
```

```powershell
curl -i http://localhost:8080/
curl -i http://localhost:8080/health
```

The expected HTTP status is `200 OK`.

## Manifest design

The Deployment has three replicas and uses a RollingUpdate strategy. Pods and the Service use the same label/selector: `app: cloudnotes`. The Service listens on port 80 and targets the named container port 5000. Resource requests/limits and HTTP health probes are configured.

## GKE mapping

The same Deployment and Service manifests can be applied to GKE after changing the image to a registry image accessible by GKE, such as an image stored in Google Artifact Registry; production exposure would normally use a cloud LoadBalancer or Ingress instead of local port-forwarding.

## Data consistency note

CloudNotes currently uses SQLite and a local uploads directory. With three replicas, those files are Pod-local. Shared persistent storage or a managed database/object-storage design would be appropriate for production, but shared storage is not required by this 4.2 assignment.

## Submission checklist

- `k8s/deployment.yaml` and `k8s/service.yaml` committed to the PR.
- Service selector matches Pod label `app: cloudnotes`.
- Video is 3–6 minutes and shows cluster readiness, manifest application, Pods, Service, browser response, and the GKE mapping.
- Drive video link is accessible to the evaluator.
