# cloud-sol


# Docker image optimization

CloudNotes now includes the Module 3.8 multi-stage Docker build:

- `Dockerfile` — optimized build + slim runtime image
- `Dockerfile.single-stage` — intentionally bloated baseline for the size comparison
- `.dockerignore` — keeps Git metadata, caches, Terraform state, and other local-only files out of the build context

## Local verification

Build the baseline and optimized images:

```bash
docker build -f Dockerfile.single-stage -t cloudnotes:single .
docker build -t cloudnotes:multi .
docker images cloudnotes
```

Run the optimized image and verify the application:

```bash
docker run --rm -d --name cloudnotes -p 8080:5000 cloudnotes:multi
curl -i http://localhost:8080/
docker history cloudnotes:multi
docker rm -f cloudnotes
```

The optimized image uses a throwaway build stage for Python dependencies, then copies only the runtime virtual environment and application files into a fresh `python:3.11-slim` image. The final container runs as the non-root `cloudnotes` user.

For the course submission, capture exactly five screenshots: the multi-stage Dockerfile, successful optimized build, `docker images` size comparison, running-container/curl verification, and `docker history` layer analysis. No cloud resources or `docker push` are required.

## 3.11 Containerized Automated Deployment

The optimized Docker image can now be built reproducibly with the root `Makefile`. The default workflow uses the free local registry at `localhost:5000` and tags every build with both a semantic version and `latest`.

```bash
make registry
make build VERSION=1.0.0
make push VERSION=1.0.0
make clean-pull VERSION=1.0.0
make run VERSION=1.0.0 PORT=8080
curl -i http://localhost:8080/
```

See `DOCKER-3.11.md` for the full workflow and screenshot checklist.



## 4.2 Kubernetes Pods, Deployments and Manifests

CloudNotes includes the required Kubernetes manifests in `k8s/`. The local-cluster version uses the image `cloudnotes:1.0.1`, which can be built directly inside Minikube without Docker Desktop.

- `k8s/deployment.yaml` — 3-replica RollingUpdate Deployment
- `k8s/service.yaml` — ClusterIP Service exposing port 80 and targeting container port 5000
- Pod label and Service selector: `app: cloudnotes`
- Flask binding: `0.0.0.0:5000`
- Health endpoint: `/health`

For Minikube:

```powershell
minikube start --driver=hyperv
minikube image build -t cloudnotes:1.0.1 .
kubectl apply -f k8s/
kubectl rollout status deployment/cloudnotes
kubectl get pods
kubectl get svc cloudnotes
kubectl get endpoints cloudnotes
kubectl port-forward svc/cloudnotes 8080:80
```

Then verify `http://localhost:8080/` returns HTTP 200. For GKE, use the same manifests with the image changed to a registry image accessible by GKE, such as Google Artifact Registry.

The local Kubernetes commands must be run on the student's machine and the observed results should be used in the video submission.
