# Terraform GCP-module for JupyterHub 

![kitchen-tests](https://github.com/BrownUniversity/terraform-gcp-jupyterhub/workflows/kitchen-tests/badge.svg)

This repository defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder.  This module builds a Kubernetes-based JupyterHub in Google Cloud as used by Brown University. 

In general this module of JupyterHub is configured as follows:

* Two pools: one for the core components, one for user pods
* Authentication (Google OAuth has been tested, other arepossible), dummy authenticator is the default.
* We currently use Infoblox to configure our DNS, we will be making that optional in the future.
* We provide scale-up and scale-down cronjobs that can change the number of replicas to have nodes be warm for users during class-time.
* Optional shared nfs volume (for shared data, for instance).

For general terraform examples see the[examples](/examples) folder. In practice we deploy one hub per class at Brown. Since most of the deployments are very simplicat, we use Terragrunt to keep configurations concise. While our deployment repository is not public at this moment, we hope to provide and example soon. 

# Contents:

- [Getting Started](#getting-started)
- [How to use this module](#how-to-use-this-module)
- [Requirements](#requirements)
- [Providers](#providers)
- [Inputs](#inputs)
- [Testing](#testing)
- [Development](#development)

## Getting Started

If developing locally, this module depends on you having GCP credentials of some kind. The module looks for a credential file in JSON format. You should export the following:

```
GOOGLE_APPLICATION_CREDENTIALS=/path/to/file.json
```

If the credentials are set correctly, the basic gcloud infrastructure is successfully created

Additionally make sure that `gcloud init` is using the appropriate service account. This is necessary because this module performs a `local exec` to get the cluster credentials. You also need to make sure that  `KUBECONFIG` or `KUBE_CONFIG_PATH` path is set. A typical error seen when the  context is not set correctly is

```
Error: error installing: Post "http://localhost/apis/apps/v1/namespaces/kube-system/deployments": dial tcp [::1]:80: connect: connection refused
```

Finally, this module also configures records in infoblox and therefore you'll need credentials to the server. For Brown users we recommend using `lastpass-cli` to source your secrets into environment variables (ask for access to creds)., ie

```
export INFOBLOX_USERNAME=$(lpass show infoblox --username)
export INFOBLOX_PASSWORD=$(lpass show infoblox --password)
export INFOBLOX_SERVER=$(lpass show infoblox --url | awk -F/ '{print $3}')
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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | >= 3.0 |
| google-beta | >= 3.0 |
| helm | ~> 1.1 |
| kubernetes | >= 1.4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate within the project | `list(string)` | `[]` | no |
| auth\_secretkeyvaluemap | Key Value Map for secret variables used by the authenticator | `map(string)` | <pre>{<br>  "auth.dummy.password": "dummy_password",<br>  "auth.dummy2.password": "dummy_password"<br>}</pre> | no |
| auth\_type | Type OAuth e.g google | `string` | `"dummy"` | no |
| auto\_create\_network | Auto create default network. | `bool` | `false` | no |
| automount\_service\_account\_token | Enable automatin mounting of the service account token | `bool` | `true` | no |
| billing\_account | Billing account id. | `string` | n/a | yes |
| cluster\_name | Cluster name | `string` | `"default"` | no |
| core\_pool\_auto\_repair | Enable auto-repair of core-component pool | `bool` | `true` | no |
| core\_pool\_auto\_upgrade | Enable auto-upgrade of core-component pool | `bool` | `true` | no |
| core\_pool\_disk\_size\_gb | Size of disk for core-component pool | `number` | `100` | no |
| core\_pool\_disk\_type | Type of disk core-component pool | `string` | `"pd-standard"` | no |
| core\_pool\_image\_type | Type of image core-component pool | `string` | `"COS"` | no |
| core\_pool\_initial\_node\_count | Number of initial nodes in core-component pool | `number` | `1` | no |
| core\_pool\_local\_ssd\_count | Number of SSDs core-component pool | `number` | `0` | no |
| core\_pool\_machine\_type | Machine type for the core-component pool | `string` | `"n1-highmem-4"` | no |
| core\_pool\_max\_count | Maximum number of nodes in the core-component pool | `number` | `3` | no |
| core\_pool\_min\_count | Minimum number of nodes in the core-component pool | `number` | `1` | no |
| core\_pool\_name | Name for the core-component pool | `string` | `"core-pool"` | no |
| core\_pool\_oauth\_scope | OAuth scope for core-component pool | `string` | `"https://www.googleapis.com/auth/cloud-platform"` | no |
| core\_pool\_preemptible | Make core-component pool preemptible | `bool` | `false` | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | `bool` | `false` | no |
| create\_tls\_secret | If set to true, user will be passing tls key and certificate to create a kubernetes secret, and use it in their helm chart | `bool` | `true` | no |
| default\_service\_account | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"delete"` | no |
| description | VPC description | `string` | `"Deployed through Terraform."` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `string` | `"true"` | no |
| dns\_manager | Service used to manage your DNS | `string` | `"infoblox"` | no |
| enable\_private\_nodes | (Beta) Whether nodes have internal IP addresses only | `bool` | `false` | no |
| folder\_id | The ID of a folder to host this project | `any` | n/a | yes |
| gcp\_zone | The GCP zone to deploy the runner into. | `string` | `"us-east1-b"` | no |
| helm\_deploy\_timeout | Time for helm to wait for deployment of chart and downloading of docker image | `number` | `1000` | no |
| helm\_repository\_url | URL for JupyterHub's Helm chart | `string` | `"https://jupyterhub.github.io/helm-chart/"` | no |
| helm\_values\_file | Relative path and file name. Example: values.yaml | `string` | n/a | yes |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon | `bool` | `false` | no |
| infoblox\_host | Infoblox host | `string` | n/a | yes |
| infoblox\_password | Password to authenticate with Infoblox server | `string` | n/a | yes |
| infoblox\_username | Username to authenticate with Infoblox server | `string` | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | `string` | `"192.168.0.0/18"` | no |
| ip\_range\_services | The secondary ip range to use for pods | `string` | `"192.168.64.0/18"` | no |
| jhub\_helm\_version | Version of the JupyterHub Helm Chart Release | `string` | n/a | yes |
| labels | Map of labels for project. | `map(string)` | <pre>{<br>  "environment": "automation",<br>  "managed_by": "terraform"<br>}</pre> | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"03:00"` | no |
| master\_ipv4\_cidr\_block | (Beta) The IP range in CIDR notation to use for the hosted master network | `string` | `"172.16.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| network | The VPC network to host the cluster in | `string` | `"kubernetes-vpc"` | no |
| network\_name | Name of the VPC. | `string` | `"kubernetes-vpc"` | no |
| network\_policy | Enable network policy addon | `bool` | `true` | no |
| org\_id | Organization id. | `number` | n/a | yes |
| project\_name | Name of the project. | `string` | n/a | yes |
| random\_project\_id | Enable random number to the end of the project. | `bool` | `true` | no |
| range\_name\_pods | The range name for pods | `string` | `"kubernetes-pods"` | no |
| range\_name\_services | The range name for services | `string` | `"kubernetes-services"` | no |
| record\_domain | The domain on the record. hostaname.domain = FQDN | `string` | n/a | yes |
| record\_hostname | The domain on the record. hostaname.domain = FQDN | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-east1"` | no |
| regional | Whether the master node should be regional or zonal | `bool` | `true` | no |
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | `bool` | `false` | no |
| routing\_mode | Routing mode. GLOBAL or REGIONAL | `string` | `"GLOBAL"` | no |
| scale\_down\_command | Command for scale-down cron job | `list(string)` | <pre>[<br>  "kubectl",<br>  "scale",<br>  "--replicas=0",<br>  "statefulset/user-placeholder"<br>]</pre> | no |
| scale\_down\_name | Name of scale-down cron job | `string` | `"scale-down"` | no |
| scale\_down\_schedule | Schedule for scale-down cron job | `string` | `"1 18 * * 1-5"` | no |
| scale\_up\_command | Command for scale-up cron job | `list(string)` | <pre>[<br>  "kubectl",<br>  "scale",<br>  "--replicas=3",<br>  "statefulset/user-placeholder"<br>]</pre> | no |
| scale\_up\_name | Name of scale-up cron job | `string` | `"scale-up"` | no |
| scale\_up\_schedule | Schedule for scale-up cron job | `string` | `"1 6 * * 1-5"` | no |
| shared\_storage\_capacity | Size of the shared volume | `number` | `5` | no |
| site\_certificate | File containing the TLS certificate | `string` | n/a | yes |
| site\_certificate\_key | File containing the TLS certificate key | `string` | n/a | yes |
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `false` | no |
| subnet\_flow\_logs | Whether the subnet will record and send flow log data to logging | `string` | `"true"` | no |
| subnet\_ip | Subnet IP CIDR. | `string` | `"10.0.0.0/17"` | no |
| subnet\_name | Name of the subnet. | `string` | `"kubernetes-subnet"` | no |
| subnet\_private\_access | Whether this subnet will have private Google access enabled | `string` | `"true"` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | `"kubernetes-subnet"` | no |
| tls\_secret\_name | TLS secret name used in secret creation, it must match with what is used by user in helm chart | `string` | `"jupyterhub-tls"` | no |
| use\_shared\_volume | Whether to use a shared NFS volume | `bool` | `false` | no |
| user\_pool\_auto\_repair | Enable auto-repair of user pool | `bool` | `true` | no |
| user\_pool\_auto\_upgrade | Enable auto-upgrade of user pool | `bool` | `true` | no |
| user\_pool\_disk\_size\_gb | Size of disk for user pool | `number` | `100` | no |
| user\_pool\_disk\_type | Type of disk user pool | `string` | `"pd-standard"` | no |
| user\_pool\_image\_type | Type of image user pool | `string` | `"COS"` | no |
| user\_pool\_initial\_node\_count | Number of initial nodes in user pool | `number` | `1` | no |
| user\_pool\_local\_ssd\_count | Number of SSDs user pool | `number` | `0` | no |
| user\_pool\_machine\_type | Machine type for the user pool | `string` | `"n1-highmem-4"` | no |
| user\_pool\_max\_count | Maximum number of nodes in the user pool | `number` | `20` | no |
| user\_pool\_min\_count | Minimum number of nodes in the user pool | `number` | `1` | no |
| user\_pool\_name | Name for the user pool | `string` | `"user-pool"` | no |
| user\_pool\_oauth\_scope | OAuth scope for user pool | `string` | `"https://www.googleapis.com/auth/cloud-platform"` | no |
| user\_pool\_preemptible | Make user pool preemptible | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| hub\_ip | Static IP assigned to the Jupyter Hub |
| location | n/a |
| project\_id | Project ID |
| project\_name | Project Name |
| region | n/a |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing

This repository uses Kitchen-Terraform to test the terraform modules. In the [examples](/examples)directory you can find examples of how each module can be used. Those examples are fed to [Test Kitchen][https://kitchen.ci/]. To install test kitchen, first make sure you have Ruby and bundler installed.

```
brew install ruby
gem install bundler
```

Then install the prerequisites for test kitchen.

```
bundle install
```

You'll need to add some common credentials and secret variables. 

And now you're ready to run test kitchen. Test kitchen has a couple main commands:

- `bundle exec kitchen create` initializes terraform.
- `bundle exec kitchen converge` runs our terraform examples.
- `bundle exec kitchen verify` runs our inspec scripts against a converged kitchen.
- `bundle exec kitchen test` does all the above.


## Development

### Merging Policy
Use [GitLab Flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html#production-branch-with-gitlab-flow).

* Create feature branches for features and fixes from default branch
* Merge only from PR with review
* After merging to default branch a release is drafted using a github action. Check the draft and publish if you and tests are happy

### Pre-commit hooks
Install and configure terraform [pre-commit hooks](https://github.com/antonbabenko/pre-commit-terraform)
This repository has the following hooks, preonfigured. After intallation, you can run them using: `pre-commit run -a`
Please make sure you run them before pushing to remote.

| Hook name                                        | Description                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `terraform_fmt`                                  | Rewrites all Terraform configuration files to a canonical format.                                                          |
| `terraform_docs`                                 | Inserts input and output documentation into `README.md`.                                                       |
| `terraform_tflint`                               | Validates all Terraform configuration files with [TFLint](https://github.com/terraform-linters/tflint).                              |
| `terraform_tfsec`                                | [TFSec](https://github.com/liamg/tfsec) static analysis of terraform templates to spot potential security issues.     |


### CI
This project has three workflows enabled:

1. PR labeler: When openning a PR to defaukt branch, a label is given assigned automatically accourding to the name of your feature branch. The labeler follows the follows rules in [pr-labeler.yml](.github/pr-labeler.yml)

2. Realease Drafter: When merging to master, a release is drafted using the [Release-Drafter Action](https://github.com/marketplace/actions/release-drafter)

3. `Kitchen test` is run on every commit unless `[skip ci]` is added to commit message.

### Maintenance/Upgrades

We aim to upgrade this package at least once a year.

#### Update Ruby Version
To install/upgrade the version of Ruby we use `rbenv`. For instance to install and update to `2.7.3`:

```
rbenv install -v 2.7.3
rbenv local 2.7.3
```

This will update the `.ruby-version` file if necessary

#### Gemfile

Look at the Gemfile and the output of `bundle outdated` to decide what to update. Usually I update the versions in the Gemfile directly, then type `bundle update`

### Update the version of Terraform

Use `tfenv` to manage your versions of terraform. You can update the version in the `.terraform-version` file and run `tfenv install` and `tf use` to install and use the version specified in the file.

You should also update the version of terraform specified in the `versions.tf` file
