# CloudNotes 3.8 Docker Optimization

## Files
- `Dockerfile`: multi-stage production-oriented build.
- `Dockerfile.single-stage`: baseline image for comparison.
- `.dockerignore`: excludes local-only and build-context noise.

## Required local commands

```bash
docker build -f Dockerfile.single-stage -t cloudnotes:single .
docker build -t cloudnotes:multi .
docker images cloudnotes
docker run --rm -d --name cloudnotes -p 8080:5000 cloudnotes:multi
curl -i http://localhost:8080/
docker history cloudnotes:multi
docker rm -f cloudnotes
```

Record the actual image sizes shown by your Docker installation; they are environment-dependent, so do not hard-code them in the repository.

The runtime image intentionally contains the files CloudNotes needs to render pages and serve the application, but does not copy the build environment from the first stage. It uses `python:3.11-slim` and a non-root user.
