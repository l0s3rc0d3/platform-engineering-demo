about:blank#blocked
TF_CMD = terraform
VAR_FILE = -var-file=backend/eu.tfvars
DIR_ALZ = terraform/alz
DIR_EKS = terraform/eks
DIR_GITOPS = terraform/gitops_bridge

.PHONY: help init apply-all destroy-all apply-alz apply-eks apply-gitops destroy-alz destroy-eks destroy-gitops

help:
	@echo "How to manage Platform Engineering Demo"
	@echo "================================================="
	@echo "Available commands:"
	@echo "  make init         - Initialization of all terraform layers"
	@echo "  make apply-all    - Create of the infrastructure (Order: ALZ -> EKS -> GitOps)"
	@echo "  make destroy-all  - Destroy of the infrastructure (Order: GitOps -> EKS -> ALZ)"
	@echo ""
	@echo "Layer-specific commands:"
	@echo "  make apply-alz, make destroy-alz"
	@echo "  make apply-eks, make destroy-eks"
	@echo "  make apply-gitops, make destroy-gitops"

init:
	@echo "==> Initialization ALZ..."
	cd $(DIR_ALZ) && $(TF_CMD) init
	@echo "==> Initialization EKS..."
	cd $(DIR_EKS) && $(TF_CMD) init
	@echo "==> Initialization GitOps Bridge..."
	cd $(DIR_GITOPS) && $(TF_CMD) init

apply-all: apply-alz apply-eks apply-gitops

apply-alz:
	@echo "==> Applying ALZ..."
	cd $(DIR_ALZ) && $(TF_CMD) apply $(VAR_FILE) -auto-approve

apply-eks:
	@echo "==> Applying EKS..."
	cd $(DIR_EKS) && $(TF_CMD) apply $(VAR_FILE) -auto-approve

apply-gitops:
	@echo "==> Applying GitOps Bridge..."
	cd $(DIR_GITOPS) && $(TF_CMD) apply $(VAR_FILE) -auto-approve

destroy-all: destroy-gitops destroy-eks destroy-alz

destroy-gitops:
	@echo "==> Destroying GitOps Bridge..."
	cd $(DIR_GITOPS) && $(TF_CMD) destroy $(VAR_FILE) -auto-approve

destroy-eks:
	@echo "==> Destroying EKS..."
	cd $(DIR_EKS) && $(TF_CMD) destroy $(VAR_FILE) -auto-approve

destroy-alz:
	@echo "==> Destroying ALZ..."
	cd $(DIR_ALZ) && $(TF_CMD) destroy $(VAR_FILE) -auto-approve