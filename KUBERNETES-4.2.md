# CloudNotes Kubernetes 4.2

This folder contains the Kubernetes Deployment and Service for the CloudNotes app.

## Image

The manifests use the image produced by the Module 3.11 workflow:

```text
localhost:5000/cloudnotes:1.0.0
```

The app listens on container port `5000`. The Kubernetes Service exposes it internally on port `80`.

## Local workflow

### 1. Start a local cluster

Use one of the assignment-approved options:

```bash
minikube start
# or
kind create cluster
# or start Docker Desktop Kubernetes
# or start k3s
```

Confirm the node is ready:

```bash
kubectl get nodes
```

### 2. Make the image available to the cluster

For a local registry workflow, first make sure the registry from Module 3.11 is running:

```bash
make registry
```

Then make `localhost:5000` reachable from your chosen local cluster. For example, with Minikube, an alternative is to load the already-built image directly:

```bash
minikube image load localhost:5000/cloudnotes:1.0.0
```

If the image is loaded directly into Minikube, you can change the Deployment image to the locally loaded tag and keep:

```yaml
imagePullPolicy: IfNotPresent
```

For Docker Desktop Kubernetes, a host-local registry may be reachable as configured by your Docker installation.

### 3. Apply the manifests

```bash
kubectl apply -f k8s/
kubectl get pods -w
kubectl get svc cloudnotes
```

Wait until all three pods show `1/1 Running`.

### 4. Verify Service wiring

```bash
kubectl get endpoints cloudnotes
```

The endpoints should not be empty.

### 5. Port-forward and test

```bash
kubectl port-forward svc/cloudnotes 8080:80
```

In another terminal:

```bash
curl -i http://localhost:8080/
```

Expected result: HTTP `200`.

You can also open:

```text
http://localhost:8080
```

in a browser.

### 6. Useful debugging commands

```bash
kubectl get deployments,pods,svc
kubectl describe deployment cloudnotes
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl rollout status deployment/cloudnotes
```

## GKE mapping

The same Deployment and Service manifests can be used on a production GKE cluster; the cluster changes from the local Kubernetes cluster to managed GKE, and production access would typically use a cloud `LoadBalancer` or `Ingress` instead of local `kubectl port-forward`.

## Submission checklist

The assignment asks for:

1. GitHub PR containing `k8s/deployment.yaml` and `k8s/service.yaml`.
2. Service selector matching the pod label `app: cloudnotes`.
3. One-line GKE mapping note in the PR description.
4. A 3–6 minute video showing:
   - `kubectl get nodes`
   - manifest application
   - pods at `1/1 Running`
   - `kubectl get svc cloudnotes`
   - CloudNotes responding in the browser
   - the GKE mapping note
