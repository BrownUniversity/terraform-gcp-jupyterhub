# Terraform GCP-module for JupyterHub 

[![terraform-tests](https://github.com/BrownUniversity/terraform-gcp-jupyterhub/actions/workflows/terraform-tests.yml/badge.svg)](https://github.com/BrownUniversity/terraform-gcp-jupyterhub/actions/workflows/terraform-tests.yml)

This repository defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder.  This module builds a Kubernetes-based JupyterHub in Google Cloud as used by Brown University. 

In general this module of JupyterHub is configured as follows:

* Two pools: one for the core components, one for user pods
* Authentication (Google OAuth has been tested, other are possible), dummy authenticator is the default.
* We currently use Infoblox to configure our DNS, we will be making that optional in the future.
* We provide scale-up and scale-down cronjobs that can change the number of replicas to have nodes be warm for users during class-time.
* Optional shared nfs volume (for shared data, for instance).

For general terraform examples see the [examples](/examples) folder. In practice we deploy one hub per class at Brown. Since most of the deployments are very similar, we use Terragrunt to keep configurations DRY. While our deployment repository is not public at this moment, we hope to provide an example soon. 


## Getting Started

This module depends on you having GCP credentials of some kind. The module looks for a credential file in JSON format. You should export the following:

```
GOOGLE_APPLICATION_CREDENTIALS=/path/to/file.json
```

If the credentials are set correctly, the basic gcloud infrastructure is successfully created

Additionally make sure that `gcloud init` is using the appropriate service account. This is necessary because this module performs a `local exec` to get the cluster credentials. You also need to make sure that  `KUBECONFIG` or `KUBE_CONFIG_PATH` path is set. A typical error seen when the  context is not set correctly is

```
Error: error installing: Post "http://localhost/apis/apps/v1/namespaces/kube-system/deployments": dial tcp [::1]:80: connect: connection refused
```

Finally, this module also configures records in infoblox and therefore you'll need credentials to the server. For Brown users we recommend using `1password-cli` to source your secrets into environment variables (ask for access to creds)., ie

```
export INFOBLOX_USERNAME=$(op item get infoblox --field username)
export INFOBLOX_PASSWORD=$(op item get infoblox --field password --reveal)
export INFOBLOX_SERVER=$(op item get infoblox --format json | jq -r '.urls[].href' | awk -F/ '{print $3}')
```

The following envs are required

```
INFOBLOX_USERNAME
INFORBOX_PASSWORD
INFOBLOX_SERVER
```


## How to use this module

This repository defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your
code by adding a `module` configuration and setting its `source` parameter to URL of this repository. See the [examples](/examples) folder for guidance


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.42.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 6.42.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.0.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.37.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.42.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_external_infoblox_record"></a> [external\_infoblox\_record](#module\_external\_infoblox\_record) | git::https://github.com/BrownUniversity/terraform-infoblox-record-a.git | v0.1.7 |
| <a name="module_gke_auth"></a> [gke\_auth](#module\_gke\_auth) | terraform-google-modules/kubernetes-engine/google//modules/auth | 37.0.0 |
| <a name="module_jhub_cluster"></a> [jhub\_cluster](#module\_jhub\_cluster) | git::https://github.com/BrownUniversity/terraform-gcp-cluster.git | v0.1.12 |
| <a name="module_jhub_helm"></a> [jhub\_helm](#module\_jhub\_helm) | ./modules/helm-jhub | n/a |
| <a name="module_jhub_project"></a> [jhub\_project](#module\_jhub\_project) | git::https://github.com/BrownUniversity/terraform-gcp-project.git | v0.1.8 |
| <a name="module_jhub_vpc"></a> [jhub\_vpc](#module\_jhub\_vpc) | git::https://github.com/BrownUniversity/terraform-gcp-vpc.git | v0.1.6 |
| <a name="module_production_infoblox_record"></a> [production\_infoblox\_record](#module\_production\_infoblox\_record) | git::https://github.com/BrownUniversity/terraform-infoblox-record-a.git | v0.1.7 |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.static](https://registry.terraform.io/providers/hashicorp/google/6.42.0/docs/resources/compute_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The list of apis to activate within the project | `list(string)` | `[]` | no |
| <a name="input_auth_secretkeyvaluemap"></a> [auth\_secretkeyvaluemap](#input\_auth\_secretkeyvaluemap) | Key Value Map for secret variables used by the authenticator | `map(string)` | <pre>{<br/>  "hub.config.DummyAuthenticator.password": "dummy_password"<br/>}</pre> | no |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | Type OAuth e.g google | `string` | `"dummy"` | no |
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | Auto create default network. | `bool` | `false` | no |
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | Enable automatin mounting of the service account token | `bool` | `true` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account id. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name | `string` | `"default"` | no |
| <a name="input_core_pool_auto_repair"></a> [core\_pool\_auto\_repair](#input\_core\_pool\_auto\_repair) | Enable auto-repair of core-component pool | `bool` | `true` | no |
| <a name="input_core_pool_auto_upgrade"></a> [core\_pool\_auto\_upgrade](#input\_core\_pool\_auto\_upgrade) | Enable auto-upgrade of core-component pool | `bool` | `true` | no |
| <a name="input_core_pool_disk_size_gb"></a> [core\_pool\_disk\_size\_gb](#input\_core\_pool\_disk\_size\_gb) | Size of disk for core-component pool | `number` | `100` | no |
| <a name="input_core_pool_disk_type"></a> [core\_pool\_disk\_type](#input\_core\_pool\_disk\_type) | Type of disk core-component pool | `string` | `"pd-standard"` | no |
| <a name="input_core_pool_image_type"></a> [core\_pool\_image\_type](#input\_core\_pool\_image\_type) | Type of image core-component pool | `string` | `"COS_CONTAINERD"` | no |
| <a name="input_core_pool_initial_node_count"></a> [core\_pool\_initial\_node\_count](#input\_core\_pool\_initial\_node\_count) | Number of initial nodes in core-component pool | `number` | `1` | no |
| <a name="input_core_pool_local_ssd_count"></a> [core\_pool\_local\_ssd\_count](#input\_core\_pool\_local\_ssd\_count) | Number of SSDs core-component pool | `number` | `0` | no |
| <a name="input_core_pool_machine_type"></a> [core\_pool\_machine\_type](#input\_core\_pool\_machine\_type) | Machine type for the core-component pool | `string` | `"n1-highmem-4"` | no |
| <a name="input_core_pool_max_count"></a> [core\_pool\_max\_count](#input\_core\_pool\_max\_count) | Maximum number of nodes in the core-component pool | `number` | `3` | no |
| <a name="input_core_pool_min_count"></a> [core\_pool\_min\_count](#input\_core\_pool\_min\_count) | Minimum number of nodes in the core-component pool | `number` | `1` | no |
| <a name="input_core_pool_name"></a> [core\_pool\_name](#input\_core\_pool\_name) | Name for the core-component pool | `string` | `"core-pool"` | no |
| <a name="input_core_pool_preemptible"></a> [core\_pool\_preemptible](#input\_core\_pool\_preemptible) | Make core-component pool preemptible | `bool` | `false` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Defines if service account specified to run nodes should be created. | `bool` | `false` | no |
| <a name="input_create_tls_secret"></a> [create\_tls\_secret](#input\_create\_tls\_secret) | If set to true, user will be passing tls key and certificate to create a kubernetes secret, and use it in their helm chart | `bool` | `true` | no |
| <a name="input_default_service_account"></a> [default\_service\_account](#input\_default\_service\_account) | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"delete"` | no |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `string` | `"true"` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | (Beta) Whether nodes have internal IP addresses only | `bool` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of a folder to host this project | `string` | n/a | yes |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | The GCP zone to deploy the runner into. | `string` | `"us-east1-b"` | no |
| <a name="input_helm_deploy_timeout"></a> [helm\_deploy\_timeout](#input\_helm\_deploy\_timeout) | Time for helm to wait for deployment of chart and downloading of docker image | `number` | `1000` | no |
| <a name="input_helm_values_file"></a> [helm\_values\_file](#input\_helm\_values\_file) | Relative path and file name. Example: values.yaml | `string` | n/a | yes |
| <a name="input_horizontal_pod_autoscaling"></a> [horizontal\_pod\_autoscaling](#input\_horizontal\_pod\_autoscaling) | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| <a name="input_http_load_balancing"></a> [http\_load\_balancing](#input\_http\_load\_balancing) | Enable httpload balancer addon | `bool` | `false` | no |
| <a name="input_jhub_helm_version"></a> [jhub\_helm\_version](#input\_jhub\_helm\_version) | Version of the JupyterHub Helm Chart Release | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels for project. | `map(string)` | <pre>{<br/>  "environment": "automation",<br/>  "managed_by": "terraform"<br/>}</pre> | no |
| <a name="input_logging_service"></a> [logging\_service](#input\_logging\_service) | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"03:00"` | no |
| <a name="input_monitoring_service"></a> [monitoring\_service](#input\_monitoring\_service) | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the VPC. | `string` | `"kubernetes-vpc"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Enable network policy addon | `bool` | `true` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization id. | `number` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project. | `string` | n/a | yes |
| <a name="input_range_name_pods"></a> [range\_name\_pods](#input\_range\_name\_pods) | The range name for pods | `string` | `"kubernetes-pods"` | no |
| <a name="input_range_name_services"></a> [range\_name\_services](#input\_range\_name\_services) | The range name for services | `string` | `"kubernetes-services"` | no |
| <a name="input_record_domain"></a> [record\_domain](#input\_record\_domain) | The domain on the record. hostaname.domain = FQDN | `string` | n/a | yes |
| <a name="input_record_hostname"></a> [record\_hostname](#input\_record\_hostname) | The domain on the record. hostaname.domain = FQDN | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host the cluster in | `string` | `"us-east1"` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | Whether the master node should be regional or zonal | `bool` | `true` | no |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | Remove default node pool while setting up the cluster | `bool` | `false` | no |
| <a name="input_scale_down_command"></a> [scale\_down\_command](#input\_scale\_down\_command) | Command for scale-down cron job | `list(string)` | <pre>[<br/>  "kubectl",<br/>  "scale",<br/>  "--replicas=0",<br/>  "statefulset/user-placeholder"<br/>]</pre> | no |
| <a name="input_scale_down_name"></a> [scale\_down\_name](#input\_scale\_down\_name) | Name of scale-down cron job | `string` | `"scale-down"` | no |
| <a name="input_scale_down_schedule"></a> [scale\_down\_schedule](#input\_scale\_down\_schedule) | Schedule for scale-down cron job | `string` | `"1 18 * * 1-5"` | no |
| <a name="input_scale_up_command"></a> [scale\_up\_command](#input\_scale\_up\_command) | Command for scale-up cron job | `list(string)` | <pre>[<br/>  "kubectl",<br/>  "scale",<br/>  "--replicas=3",<br/>  "statefulset/user-placeholder"<br/>]</pre> | no |
| <a name="input_scale_up_name"></a> [scale\_up\_name](#input\_scale\_up\_name) | Name of scale-up cron job | `string` | `"scale-up"` | no |
| <a name="input_scale_up_schedule"></a> [scale\_up\_schedule](#input\_scale\_up\_schedule) | Schedule for scale-up cron job | `string` | `"1 6 * * 1-5"` | no |
| <a name="input_shared_storage_capacity"></a> [shared\_storage\_capacity](#input\_shared\_storage\_capacity) | Size of the shared volume | `number` | `5` | no |
| <a name="input_site_certificate"></a> [site\_certificate](#input\_site\_certificate) | File containing the TLS certificate | `string` | n/a | yes |
| <a name="input_site_certificate_key"></a> [site\_certificate\_key](#input\_site\_certificate\_key) | File containing the TLS certificate key | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the subnet. | `string` | `"kubernetes-subnet"` | no |
| <a name="input_tls_secret_name"></a> [tls\_secret\_name](#input\_tls\_secret\_name) | TLS secret name used in secret creation, it must match with what is used by user in helm chart | `string` | `"jupyterhub-tls"` | no |
| <a name="input_use_shared_volume"></a> [use\_shared\_volume](#input\_use\_shared\_volume) | Whether to use a shared NFS volume | `bool` | `false` | no |
| <a name="input_user_pool_auto_repair"></a> [user\_pool\_auto\_repair](#input\_user\_pool\_auto\_repair) | Enable auto-repair of user pool | `bool` | `true` | no |
| <a name="input_user_pool_auto_upgrade"></a> [user\_pool\_auto\_upgrade](#input\_user\_pool\_auto\_upgrade) | Enable auto-upgrade of user pool | `bool` | `true` | no |
| <a name="input_user_pool_disk_size_gb"></a> [user\_pool\_disk\_size\_gb](#input\_user\_pool\_disk\_size\_gb) | Size of disk for user pool | `number` | `100` | no |
| <a name="input_user_pool_disk_type"></a> [user\_pool\_disk\_type](#input\_user\_pool\_disk\_type) | Type of disk user pool | `string` | `"pd-standard"` | no |
| <a name="input_user_pool_image_type"></a> [user\_pool\_image\_type](#input\_user\_pool\_image\_type) | Type of image user pool | `string` | `"COS_CONTAINERD"` | no |
| <a name="input_user_pool_initial_node_count"></a> [user\_pool\_initial\_node\_count](#input\_user\_pool\_initial\_node\_count) | Number of initial nodes in user pool | `number` | `1` | no |
| <a name="input_user_pool_local_ssd_count"></a> [user\_pool\_local\_ssd\_count](#input\_user\_pool\_local\_ssd\_count) | Number of SSDs user pool | `number` | `0` | no |
| <a name="input_user_pool_machine_type"></a> [user\_pool\_machine\_type](#input\_user\_pool\_machine\_type) | Machine type for the user pool | `string` | `"n1-highmem-4"` | no |
| <a name="input_user_pool_max_count"></a> [user\_pool\_max\_count](#input\_user\_pool\_max\_count) | Maximum number of nodes in the user pool | `number` | `20` | no |
| <a name="input_user_pool_min_count"></a> [user\_pool\_min\_count](#input\_user\_pool\_min\_count) | Minimum number of nodes in the user pool | `number` | `1` | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | Name for the user pool | `string` | `"user-pool"` | no |
| <a name="input_user_pool_preemptible"></a> [user\_pool\_preemptible](#input\_user\_pool\_preemptible) | Make user pool preemptible | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Cluster name |
| <a name="output_hub_ip"></a> [hub\_ip](#output\_hub\_ip) | Static IP assigned to the Jupyter Hub |
| <a name="output_location"></a> [location](#output\_location) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project Name |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_zones"></a> [zones](#output\_zones) | List of zones in which the cluster resides |
<!-- END_TF_DOCS -->


## Local Development

### Merging Policy
Use [GitLab Flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html#production-branch-with-gitlab-flow).

* Create feature branches for features and fixes from default branch
* Merge only from PR with review
* After merging to default branch a release is drafted using a github action. Check the draft and publish if you and tests are happy

### Terraform

We recommend installing the latest version of terraform whenever you are updating this module. The current terraform version for this module is 1.9.2. You can install terraform with homebrew.

#### Pre-commit hooks
You should make sure that pre-commit hooks are installed to run the formater, linter, etc. Install and configure terraform [pre-commit hooks](https://github.com/antonbabenko/pre-commit-terraform) as follows:

Install dependencies

```
brew bundle install
```

Install the pre-commit hook globally
```
DIR=~/.git-template
git config --global init.templateDir ${DIR}
pre-commit init-templatedir -t pre-commit ${DIR}
```

To run the hooks specified in `.pre-commit-config.yaml`: 

```
pre-commit run -a

| Hook name                                        | Description                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `terraform_fmt`                                  | Rewrites all Terraform configuration files to a canonical format.                                                          |
| `terraform_docs`                                 | Inserts input and output documentation into `README.md`.                                                       |
| `terraform_tflint`                               | Validates all Terraform configuration files with [TFLint](https://github.com/terraform-linters/tflint).                              |
| `terraform_tfsec`                                | [TFSec](https://github.com/liamg/tfsec) static analysis of terraform templates to spot potential security issues.     |
```

### GCloud and Infoblox Secrets

This is only needed if running tests locally. The google-cloud-sdk and last-pass cli are included in the Brewfile so it should now be installed

This repo includes a `env.sh` file that where you set the path to the google credentials file and infoblox secrets. First you'll need to make sure you are logged in to last pass,

```
eval $(op signin) 
```

Then use

```
source env.sh
```

to set the related environment variables. If you need to unset them, you can use

```
deactivate
```

As of 2022-08 Gcloud authentication needs an additional plugin to be installed. Run

```
gcloud components install gke-gcloud-auth-plugin
```

See [here](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke) for more information.




## Testing

This repository uses the native terraform tests to test the modules. In the [tests](/tests) directory you can find examples of how each module can be used and the test scripts.

### Setup secrets

In addition to the GCLOUD and INFOBLOX variables configured by the `env.sh` file, we also need to add some additional secret variables. 

In the example folders, rename the following files:
- `local-example.tfvars` to `secrets.auto.tfvars`
- `local-example.yaml` to `secrets.yaml`

Set the corresponding values inside of the files. They should automatically be ignored via our `.gitignore` file

### Run the tests

Use the `terraform test` command to test the modules in this repo. You can also specify the name of the files to run each test individually:

```sh
terraform test -filter=tests/test-sample-jhub.tftest.hcl      # runs the test without nfs
terraform test -filter=tests/test-sample-jhub-nfs.tftest.hcl  # runs the test with nfs
```

### Running terraform in a container

If you need finer control when trouble shooting, you can directly run terraform within the container specified by the Dockerfile.

First, build the Dockerfile with:

```sh
docker build -t <image_name> --platform linux/amd64 .
```

Note that `--platform linux/amd64` is necessary for ARM-based systems (e.g. Apple Silicon Macs).

Then run the docker container with

```sh
docker run -t -d -v $(pwd):/usr/app --platform linux/amd64 <image_name>
```

Finally, you can get a shell inside the running container with:

```sh
docker exec -it <container_name> /bin/bash
```

Follow the next section to authenticate to Google Cloud and 1Password.

## Troubleshooting

Further troubleshooting will require interacting with the kubernetes cluster directly, and you'll need to authenticate to the cluster. You can do so for instance as follows,

```
PROJECT=jhub-sample-xxxxx
ZONE=us-east1-b

gcloud container clusters get-credentials default --zone ${ZONE} --project ${PROJECT}
```

If gcloud is not authenticated, then do so as follows

```
gcloud auth activate-service-account <service-account> --key-file=<path-tojson-credentials>
--project=$PROJECT
```

## CI

This project has three workflows enabled:

1. PR labeler: When opening a PR to the main branch, a label is given assigned automatically according to the name of your feature branch. The labeler follows the follows rules in [pr-labeler.yml](.github/pr-labeler.yml)

2. Release Drafter: When merging to master, a release is drafted using the [Release-Drafter Action](https://github.com/marketplace/actions/release-drafter)

3. `terraform test` is run on every commit unless `[skip ci]` is added to commit message.

### Maintenance/Upgrades

We aim to upgrade this package at least once a year.

### Update the version of Terraform

Use `tfenv` to manage your versions of terraform. You can update the version in the `.terraform-version` file and run `tfenv install` and `tf use` to install and use the version specified in the file.

You should also update the version of terraform specified in the `versions.tf` file
