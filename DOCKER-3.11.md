# CloudNotes 3.11 — Containerized Automated Deployment

This project uses the optimized multi-stage `Dockerfile` from 3.8 and adds a reproducible build/publish workflow.

## Default: free local registry

The Makefile defaults to:

```text
localhost:5000/cloudnotes
```

This avoids Docker Hub credentials and paid cloud registries.

### 1. Start a local registry

```bash
make registry
```

If the registry already exists, the command is harmless.

### 2. Build with semantic version + latest

```bash
make build VERSION=1.0.0
```

This creates both:

```text
localhost:5000/cloudnotes:1.0.0
localhost:5000/cloudnotes:latest
```

Check:

```bash
docker images | grep cloudnotes
```

### 3. Push

```bash
make push VERSION=1.0.0
```

Or build and push in one reproducible command:

```bash
make publish VERSION=1.0.0
```

### 4. Verify from a clean local state

Remove the versioned local image first, then pull it back from the registry:

```bash
make clean-pull VERSION=1.0.0
make run VERSION=1.0.0 PORT=8080
curl -i http://localhost:8080/
```

You should receive an HTTP 200 response.

Or run the complete verification flow:

```bash
make verify VERSION=1.0.0 PORT=8080
```

## Docker Hub alternative

Set your Docker Hub namespace when invoking Make:

```bash
docker login
make build IMAGE=myuser/cloudnotes VERSION=1.0.0
make push IMAGE=myuser/cloudnotes VERSION=1.0.0
```

Then verify from a clean state:

```bash
docker rmi myuser/cloudnotes:1.0.0
docker pull myuser/cloudnotes:1.0.0
docker run -d --name cloudnotes -p 8080:5000 myuser/cloudnotes:1.0.0
curl -i http://localhost:8080/
```

## Five required screenshots

1. `Makefile` showing the automated build.
2. `make build VERSION=1.0.0` completing successfully.
3. `docker images | grep cloudnotes` showing `1.0.0` and `latest`.
4. `make push VERSION=1.0.0` showing a successful registry push.
5. Clean pull + container run + `curl -i http://localhost:8080/` showing CloudNotes responding.

Do not claim successful build/push/pull results until they have actually been run on the local Docker installation.
