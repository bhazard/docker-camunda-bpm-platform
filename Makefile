# The AWS repository must be created before publishing.  
# 
# Prior to publishing, the user must auth against the target registry.  This
# requires that an IAM user exist that has permission to publish and interact
# with the registry and repositories in the selected AWSACCOUNT.  Create
# the IAM user with Admin privs, and download the credentials to your
# ~/.aws/credentials file.  For convenience, set these as your default profile.
# Now, get the login token via:
#   aws ecr get-login --no-include-email --region us-east-2
# This returns a command to perform the login, something like:
#   docker login -u AWS -p <long token thing> -e none https://<account>.dkr.ecr.<region>.amazonaws.com
# To do this in one wack in bash:
#   $(aws ecr get-login --no-include-email --region us-east-2)

# AWSACCOUNT=091235034633
# AWSREGION=us-east-2
# REPOURL=$(AWSACCOUNT).dkr.ecr.$(AWSREGION).amazonaws.com
REPONAME=bhazard
IMAGENAME=$(REPONAME)/camunda
CONTAINERNAME=camunda
# LOCAL_AIRFLOW_HOME=/airflow/
CAMUNDA_VERSION=7.10.0
TAG=$(CAMUNDA_VERSION)
DOCKERFLAGS=--build-arg VERSION=$(CAMUNDA_VERSION)
DOCKERPORTS=-p 8084:8080

include docker.mk

# 8080 - camunda main ui
run: build
	docker run $(DOCKERPORTS) --name $(CONTAINERNAME) $(IMAGENAME):$(TAG)

#	docker run -p  --name $(CONTAINERNAME) $(IMAGENAME):$(TAG)

# -----------------------------------------------------------------------------
# Testing -- use goss for testing container health
# -----------------------------------------------------------------------------

test:
	dgoss run $(DOCKERPORTS) $(IMAGENAME):$(TAG)

test-edit:
	dgoss edit $(DOCKERPORTS) $(IMAGENAME):$(TAG)

# dirs:
# 	mkdir -p $(LOCAL_AIRFLOW_HOME)

cleancontainer:
	docker container rm $(CONTAINERNAME)

clean: cleancontainer

squeaky: clean
