include ../Makefile.base

NAME=devops
VERSION=1.0
RANDOM=$(shell /bin/bash -c "echo $$RANDOM")

run:
	docker run -i --rm -t \
		--name devops-$(RANDOM) \
		-e "AWS_DEFAULT_PROFILE=originalgremlin" \
		-e "AWS_DEFAULT_REGION=us-east-1" \
		-e "AWS_PROFILE=originalgremlin" \
		-e "TERRAFORM_ROOT=/usr/local/data/terraform" \
		-e "TF_VAR_hostname=redbooth.com" \
		-e "TF_VAR_region=us-east-1" \
		-e "TF_VAR_profile=originalgremlin" \
		-v ~/.aws:/root/.aws \
		-v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
		-v ~/.ssh/known_hosts:/root/.ssh/known_hosts \
		-v $(CURDIR)/..:/usr/local/data \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(IMAGE_NAME):$(VERSION)
