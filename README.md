# AWS Platform Engineering Showcase: Vpc + Eks modular infrastructure

## Key Features:

- Terraform projects are small on purpose i want to avoid to have a big cauldron, it's better to divide in multiple projects to enhance the maintainability of the iac
- Terraform projects are shaped so a dr solution would be easy
- Terraform project are shaped in a way that you have to just fill in the var file to reduce the complexity
- Vpc private endpoints enabled
- Eks control plane is publicly reachable (cause is a demo) and we use an ip whitelist to filter the reachability
- Eks workloads should be completly stateless and for data persistence use aws s3 (loki/tempo/mimir are compatible, grafana should use an external db configured in aws rds )

## To do:

- IMPORTANT: change anti affinity rule to preferredDuringSchedulingIgnoredDuringExecution instead of requiredDuringSchedulingIgnoredDuringExecution to let 
  platform engineering team scale platform engineering applications in special cases (like argo if it has to sync a lot of apps at the same time)
- Add the platform application following gitops principles like (karpenter/keda/grafana/loki/tempo/mimir)
- Expands access entries to include eks AmazonEKSViewPolicy for devs
- Add business application gitops structure
- Use aws cognito and integrate argocd login with it

### How to execute

Beware! Before run there are some placeholder here and there for example:
- iam used in eks project for assignment of permissions under access_entries
- ip whitelist to access the eks control plane, cause this is a demo i set up the control plane as public in a production environment the control plane would be private
In each folder under the terraform one you can just run:

```
terraform init
terraform apply -var-file="./backend/eu.tfvars"
```

and then when is finished:

```
terraform destroy -var-file="./backend/eu.tfvars"
```
or after the introduction of Makefile
```
make apply-all
```
to execute the entire infrastructure

use:
```
make help
```
to discover all configured commands
