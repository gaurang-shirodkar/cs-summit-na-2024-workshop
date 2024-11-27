# Set the default goal to deploy-all
.DEFAULT_GOAL := deploy-all

# Terraform directories
EKS_DIR=eks
SYSDIG_TENANT_DIR=sysdig_tenant_setup
SYSDIG_SECURE=sysdig_secure
ADDITIONAL_RESOURCES_DIR=additional_resources

# Helper function to check if .env file exists and load it
define load_env
	@if [ ! -f .env ]; then \
		echo ".env file not found!"; \
		exit 1; \
	else \
		echo "Sourcing .env file"; \
		set -a; source .env; set +a; \
	fi
endef

# Deploy all environments
deploy-all: deploy-vpc deploy-eks deploy-sysdig-tenant deploy-additional-resources

############################################
##### Deploy environments individually #####
############################################
destroy-all: destroy-additional-resources destroy-eks destroy-vpc destroy-sysdig-tenant

deploy-eks:
	@$(load_env) && cd $(EKS_DIR) && terraform init && terraform apply -auto-approve

deploy-vpc:
	@$(load_env) && cd $(EKS_DIR) && terraform init && terraform apply --target=module.vpc -auto-approve

deploy-additional-resources:
	@$(load_env) && cd $(ADDITIONAL_RESOURCES_DIR) && terraform init && terraform apply -auto-approve

deploy-sysdig-tenant:
	@$(load_env) && cd $(SYSDIG_TENANT_DIR) && terraform init && terraform apply -auto-approve

deploy-sysdig-secure:
	@$(load_env) && cd $(SYSDIG_SECURE) && terraform init && terraform apply -auto-approve

############################################
##### Destroy environments individually #####
############################################

destroy-vpc:
	@$(load_env) && cd $(EKS_DIR) && terraform init && terraform destroy --target=module.vpc -auto-approve

destroy-eks:
	@$(load_env) && cd $(EKS_DIR) && terraform init && terraform destroy -auto-approve

destroy-sysdig-tenant:
	@$(load_env) && cd $(SYSDIG_TENANT_DIR) && terraform init && terraform destroy -auto-approve

destroy-sysdig-secure:
	@$(load_env) && cd $(SYSDIG_SECURE) && terraform init && terraform destroy -auto-approve

destroy-additional-resources:
	@$(load_env) && cd $(ADDITIONAL_RESOURCES_DIR) && terraform init && terraform destroy -auto-approve
