# AWS Platform Engineering Showcase: Vpc + Eks modular infrastructure

## Key Features:

- Terraform projects are little on purpose i want to avoid to have a big cauldron, it's better to divide in multiple project to enhance the maintainability of the iac
- Terraform projects are shaped so a dr solution would be easy
- Terraform project are shaped in a way that you have to just fill in the var file to reduce the complexity
- Vpc multi-az with non routable ip ranges for eks pods
- Vpc private endpoints enabled
- Eks control plane is publicly reachable (cause is a demo) and we use an ip whitelist to filter the reachability
- Eks addons are empty on purpose (will be managed by a separate project)

## To do:

- Run the eks project with success (first run has failed for a silly mistake...)
- Create another project to manage eks addons
- Setup the gitops process with argocd

Could be an interesting thing to manage addons and argocd with the following module: https://github.com/aws-ia/terraform-aws-eks-blueprints-addons

### How to execute

Beware! Before run there are some placeholder here and there...
In each folder under the terraform one you can just run:

```
terraform init
terraform apply -var-file="./backend/eu.tfvars"
```

and then when is finished:

```
terraform destroy -var-file="./backend/eu.tfvars"
```
