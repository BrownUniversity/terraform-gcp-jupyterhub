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
| activate\_apis | The list of apis to activate within the project | `list(string)` | `[]` | no |
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
| default\_service\_account | Project default service account setting: can be one of delete, depriviledge, or keep. | `string` | `"delete"` | no |
| description | VPC description | `string` | `"Deployed through Terraform."` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. | `string` | `"true"` | no |
| enable\_private\_nodes | (Beta) Whether nodes have internal IP addresses only | `bool` | `false` | no |
| folder\_id | The ID of a folder to host this project | `any` | n/a | yes |
| gcp\_zone | The GCP zone to deploy the runner into. | `string` | `"us-east1-b"` | no |
| helm\_deploy\_timeout | Time for helm to wait for deployment of chart and downloading of docker image | `number` | `1000` | no |
| helm\_repository\_url | URL for JupyterHub's Helm chart | `string` | `"https://jupyterhub.github.io/helm-chart/"` | no |
| helm\_secrets\_file | Relative path and file name. Example: secrets.yaml | `string` | n/a | yes |
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
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `false` | no |
| subnet\_flow\_logs | Whether the subnet will record and send flow log data to logging | `string` | `"true"` | no |
| subnet\_ip | Subnet IP CIDR. | `string` | `"10.0.0.0/17"` | no |
| subnet\_name | Name of the subnet. | `string` | `"kubernetes-subnet"` | no |
| subnet\_private\_access | Whether this subnet will have private Google access enabled | `string` | `"true"` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | `"kubernetes-subnet"` | no |
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