IMAGE ?= localhost:5000/cloudnotes
VERSION ?= 1.0.1
PORT ?= 8080
CONTAINER_NAME ?= cloudnotes

.PHONY: build tag registry push publish clean-pull run verify

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

tag:
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest

registry:
	docker run -d -p 5000:5000 --name cloudnotes-registry registry:2 || true

push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

publish: build push

clean-pull:
	-docker rm -f $(CONTAINER_NAME)
	-docker rmi $(IMAGE):$(VERSION)
	docker pull $(IMAGE):$(VERSION)

run:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):5000 $(IMAGE):$(VERSION)

verify: clean-pull run
	sleep 2
	curl -i http://localhost:$(PORT)/health

clean:
	-docker rm -f $(CONTAINER_NAME)
