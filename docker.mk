# Common Docker targets
# This file should be included in a parent Makefile.  The parent Makefile should
# define:
# IMAGENAME
# REGION
# REPONAME
# TAG
# REPOURL
.PHONY: build

# Build the IMAGE using the local Dockerfile; tag it in the local Docker repo
build: Dockerfile 
	docker build $(DOCKERFLAGS) -t $(IMAGENAME) .
	# Add the chosen tag to "latest" (what we just built)
	docker tag $(IMAGENAME):latest $(IMAGENAME):$(TAG)

# Create the AWS repository
aws-repo:
	aws ecr create-repository --region $(REGION) --repository-name $(REPONAME)

# Push the local image to the AWS repository
pub publish: build
	# Add the AWS tags (latest and TAG)
	docker tag $(IMAGENAME):$(TAG) $(REPOURL)/$(REPONAME):$(TAG)
	docker tag $(IMAGENAME):latest $(REPOURL)/$(REPONAME):latest
	# And push them
	docker push $(REPOURL)/$(REPONAME):$(TAG)
	docker push $(REPOURL)/$(REPONAME):latest

# Tag the image
tag:
	docker tag $(REPOURL)/$(REPONAME):$(TAG) $(REPOURL)/$(REPONAME):latest
	docker tag $(REPOURL)/$(REPONAME):latest $(REPOURL)/$(REPONAME):$(TAG)

# Create a version file (why do we need this again?)
version:
	echo Creating version file.
	@echo Image: $(IMAGENAME) > version
	@echo Repo: $(REPONAME) >> version
	@echo Version: $(TAG) >> version
	@echo Date: $$(date) >> version
