VPC_ID:=$(shell cd "$(TERRAFORM_ROOT)" && terraform output -module=networking vpc_id)
SUBNET_ID:=$(shell cd "$(TERRAFORM_ROOT)" && terraform output -json -module=networking public_subnet_ids | jq --raw-output .value[0])
ADMIN_PASSWORD:=$(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
ROOT_PASSWORD:=$(shell cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

build:
	packer build \
		-var "subnet_id=$(SUBNET_ID)" \
		-var "vpc_id=$(VPC_ID)" \
		-var "admin_password=$(ADMIN_PASSWORD)" \
		-var "root_password=$(ROOT_PASSWORD)" \
		debian.json

push:
    echo TODO: bundle overlay dir and upload to S3 bucket
