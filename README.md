# cpny-cicd (WIP)

A company CI/CD tools, scripts, the application manifests, definitions

## Prerequisites

It requires:
* Linux packages `jq`, `base-devel` tools
* Terraform, version ~> 1.2
* kubectl, version ~> 1.22
* awscli2, version ~> 2.7

It's supposed that:
1. A respective AWS infrastructure are already provisioned by a terraform
configuration `cpny-terraform-infra` and the terraform configuration directory is
cloned in the same directory as the current project.

2. An service images with tag 0.0.1 are provisioned to the respective ECRs
(project `cpny-webapp`)

## Deploy Application Manually

To deploy application, required:
1. Configure `kubectl` for interacting with an EKS cluster provisioned by
terraform configuration `cpny-terraform-infra` by command `bin/cpny-setup-kubeconfig.sh`

It adds a context with a name of the EKS cluster provisioned by Terraform and
make the context active.

*NB* Ensure that the cluster available by kubectl before going to the next step.
Use command `kubectl get nodes` for example.

2. Ensure that images tagged as 0.0.1 exists in its ECRs. Make initial upload the
application with command `bin/cpny-deploy-application.sh`

3. Make alias record in Route53 for the application domain name to an ingress ELB
by script `bin/cpny-setup-application-domain.sh` (isn't completed right now)

## Automated Deployment (Not Implemented)

1. CI options:
   * Git Actions
   * Jenkins

2. CD options:
   * AWS CloudFormation
   * FluxCD/ArgoCD and so on
   * Jenkins
