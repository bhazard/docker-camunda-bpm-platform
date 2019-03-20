# Makefile to support docker camunda container build and run
REPONAME=bhazard
IMAGENAME=$(REPONAME)/camunda
CONTAINERNAME=camunda
CAMUNDA_VERSION=7.10.0
TAG=$(CAMUNDA_VERSION)
DOCKERFLAGS=--build-arg VERSION=$(CAMUNDA_VERSION)
DOCKERPORTS=-p 8084:8080

include docker.mk

# 8080 - camunda main ui
run: build
	#	docker run $(DOCKERPORTS) --name $(CONTAINERNAME) $(IMAGENAME):$(TAG)
	docker-compose up

stop:
	-docker-compose down

# -----------------------------------------------------------------------------
# Testing -- use goss for testing container health
# -----------------------------------------------------------------------------

test:
	dgoss run $(DOCKERPORTS) $(IMAGENAME):$(TAG)

test-edit:
	dgoss edit $(DOCKERPORTS) $(IMAGENAME):$(TAG)

clean: cleancontainer

squeaky: stop clean cleanimage
