
.PHONY: help

TAG	?= build
CI_TAG ?= ci
HUB	?= quay.io/3scale
IMAGE	?= quay.io/3scale/soyuz

help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

release-build: build push-$(CI_TAG)

release-push: push push-$(CI_TAG)

latest-build: build-latest build-$(CI_TAG)-latest

latest-push: push-latest push-$(CI_TAG)-latest

build-all: build build-ci

build:
	docker build -t $(IMAGE):$(TAG) -f Dockerfile .

push:
	docker push $(IMAGE):$(TAG)

build-latest: build
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest

push-latest: build-latest
	docker push $(IMAGE):latest

build-$(CI_TAG):
	docker build -t $(IMAGE):$(TAG)-$(CI_TAG) -f Dockerfile-$(CI_TAG) .

push-$(CI_TAG): build-$(CI_TAG)
	docker push $(IMAGE):$(TAG)-$(CI_TAG)

build-$(CI_TAG)-latest: build-$(CI_TAG)
	docker tag $(IMAGE):$(TAG)-$(CI_TAG) $(IMAGE):latest-$(CI_TAG)

push-$(CI_TAG)-latest: build-$(CI_TAG)-latest
	docker push $(IMAGE):latest-$(CI_TAG)
