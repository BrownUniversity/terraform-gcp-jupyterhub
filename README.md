# Terraform GCP-module for JupyterHub 

This repository defines a [Terraform module](https://www.terraform.io/docs/modules/usage.html), which you can use in your code by adding a `module` configuration and setting its `source` parameter to URL of this folder.  See the [examples](/examples) folder for guidance


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | >= 3.0 |
| google-beta | >= 3.0 |
| helm | ~> 1.0 |
| kubernetes | >= 1.4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate within the project | `list` | <pre>[<br>  "compute.googleapis.com",<br>  "container.googleapis.com",<br>  "containerregistry.googleapis.com"<br>]</pre> | no |
| auto\_create\_network | Auto create default network. | `bool` | `false` | no |
| automount\_service\_account\_token | n/a | `bool` | `true` | no |
| billing\_account | Billing account id. | `any` | n/a | yes |
| cluster\_name | Cluster name | `string` | `"default"` | no |
| core\_pool\_auto\_repair | n/a | `bool` | `true` | no |
| core\_pool\_auto\_upgrade | n/a | `bool` | `true` | no |
| core\_pool\_disk\_size\_gb | n/a | `number` | `100` | no |
| core\_pool\_disk\_type | n/a | `string` | `"pd-standard"` | no |
| core\_pool\_image\_type | n/a | `string` | `"COS"` | no |
| core\_pool\_initial\_node\_count | n/a | `number` | `1` | no |
| core\_pool\_local\_ssd\_count | n/a | `number` | `0` | no |
| core\_pool\_machine\_type | n/a | `string` | `"n1-highmem-4"` | no |
| core\_pool\_max\_count | n/a | `number` | `3` | no |
| core\_pool\_min\_count | n/a | `number` | `1` | no |
| core\_pool\_name | n/a | `string` | `"core-pool"` | no |
| core\_pool\_oauth\_scope | n/a | `string` | `"https://www.googleapis.com/auth/cloud-platform"` | no |
| core\_pool\_preemptible | n/a | `bool` | `false` | no |
| create\_service\_account | n/a | `string` | `"false"` | no |
| default\_service\_account | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"delete"` | no |
| description | n/a | `string` | `"Deployed through Terraform."` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `string` | `"true"` | no |
| enable\_private\_nodes | n/a | `bool` | `false` | no |
| folder\_id | The ID of a folder to host this project | `any` | n/a | yes |
| gcp\_zone | The GCP zone to deploy the runner into. | `string` | n/a | yes |
| helm\_deploy\_timeout | Time for helm to wait for deployment of chart and downloading of docker image | `number` | `1000` | no |
| helm\_repository\_url | n/a | `string` | `"https://jupyterhub.github.io/helm-chart/"` | no |
| helm\_secrets\_file | Relative path and file name. Example: secrets.yaml | `any` | n/a | yes |
| helm\_values\_file | Relative path and file name. Example: values.yaml | `any` | n/a | yes |
| horizontal\_pod\_autoscaling | n/a | `bool` | `true` | no |
| http\_load\_balancing | n/a | `bool` | `false` | no |
| infoblox\_host | n/a | `any` | n/a | yes |
| infoblox\_password | n/a | `any` | n/a | yes |
| infoblox\_username | INFOBLOX | `any` | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | `string` | `"192.168.0.0/18"` | no |
| ip\_range\_services | The secondary ip range to use for pods | `string` | `"192.168.64.0/18"` | no |
| jhub\_helm\_version | Version of the JupyterHub Helm Chart Release | `any` | n/a | yes |
| labels | Map of labels for project. | `map` | <pre>{<br>  "environment": "automation",<br>  "managed_by": "terraform"<br>}</pre> | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"03:00"` | no |
| master\_ipv4\_cidr\_block | n/a | `string` | `"172.16.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| network | The VPC network to host the cluster in | `string` | `"kubernetes-vpc"` | no |
| network\_name | Name of the VPC. | `string` | `"kubernetes-vpc"` | no |
| network\_policy | n/a | `bool` | `true` | no |
| org\_id | Organization id. | `any` | n/a | yes |
| project\_name | Name of the project. | `any` | n/a | yes |
| random\_project\_id | Enable random number to the end of the project. | `bool` | `true` | no |
| range\_name\_pods | The range name for pods | `string` | `"kubernetes-pods"` | no |
| range\_name\_services | The range name for services | `string` | `"kubernetes-services"` | no |
| record\_domain | n/a | `any` | n/a | yes |
| record\_hostname | n/a | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| regional | n/a | `bool` | `true` | no |
| remove\_default\_node\_pool | n/a | `bool` | `false` | no |
| routing\_mode | Routing mode. GLOBAL or REGIONAL | `string` | `"GLOBAL"` | no |
| scale\_down\_command | n/a | `list` | <pre>[<br>  "kubectl",<br>  "scale",<br>  "--replicas=0",<br>  "statefulset/user-placeholder"<br>]</pre> | no |
| scale\_down\_name | n/a | `string` | `"scale-down"` | no |
| scale\_down\_schedule | n/a | `string` | `"1 18 * * 1-5"` | no |
| scale\_up\_command | n/a | `list` | <pre>[<br>  "kubectl",<br>  "scale",<br>  "--replicas=3",<br>  "statefulset/user-placeholder"<br>]</pre> | no |
| scale\_up\_name | n/a | `string` | `"scale-up"` | no |
| scale\_up\_schedule | n/a | `string` | `"1 6 * * 1-5"` | no |
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `false` | no |
| subnet\_flow\_logs | n/a | `string` | `"true"` | no |
| subnet\_ip | Subnet IP CIDR. | `string` | `"10.0.0.0/17"` | no |
| subnet\_name | Name of the subnet. | `string` | `"kubernetes-subnet"` | no |
| subnet\_private\_access | n/a | `string` | `"true"` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | `"kubernetes-subnet"` | no |
| user\_pool\_auto\_repair | n/a | `bool` | `true` | no |
| user\_pool\_auto\_upgrade | n/a | `bool` | `true` | no |
| user\_pool\_disk\_size\_gb | n/a | `number` | `100` | no |
| user\_pool\_disk\_type | n/a | `string` | `"pd-standard"` | no |
| user\_pool\_image\_type | n/a | `string` | `"COS"` | no |
| user\_pool\_initial\_node\_count | n/a | `number` | `1` | no |
| user\_pool\_local\_ssd\_count | n/a | `number` | `0` | no |
| user\_pool\_machine\_type | n/a | `string` | `"n1-highmem-8"` | no |
| user\_pool\_max\_count | n/a | `number` | `3` | no |
| user\_pool\_min\_count | n/a | `number` | `1` | no |
| user\_pool\_name | n/a | `string` | `"user-pool"` | no |
| user\_pool\_oauth\_scope | n/a | `string` | `"https://www.googleapis.com/auth/cloud-platform"` | no |
| user\_pool\_preemptible | n/a | `bool` | `false` | no |

## Outputs

No output.

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

You'll need to add some common credentials and secret variables

And now you're ready to run test kitchen. Test kitchen has a couple main commands:

- `bundle exec kitchen create` initializes terraform.
- `bundle exec kitchen converge` runs our terraform examples.
- `bundle exec kitchen verify` runs our inspec scripts against a converged kitchen.
- `bundle exec kitchen test` does all the above.


## Development

Install and configure terraform [pre-commit hooks](https://github.com/antonbabenko/pre-commit-terraform)
To run them: `pre-commit run -a`