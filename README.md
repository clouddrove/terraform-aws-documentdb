<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS DocumentDB
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create documentdb resource on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.1.7-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>
<a href="https://github.com/clouddrove/terraform-aws-documentdb/actions/workflows/tfsec.yaml">
  <img src="https://github.com/clouddrove/terraform-aws-documentdb/actions/workflows/tfsec.yaml/badge.svg" alt="tfsec">
</a>
<a href="https://github.com/clouddrove/terraform-aws-documentdb/actions/workflows/terraform.yaml">
  <img src="https://github.com/clouddrove/terraform-aws-documentdb/actions/workflows/terraform.yaml/badge.svg" alt="static-checks">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-documentdb'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+DocumentDB&url=https://github.com/clouddrove/terraform-aws-documentdb'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+DocumentDB&url=https://github.com/clouddrove/terraform-aws-documentdb'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-documentdb/releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
  ```hcl
module "documentdb" {
  source = "clouddrove/terraform-aws-documentdb/aws"
  vpc_id                = module.vpc.vpc_id
  subnet_list           = module.subnets.private_subnet_id
  database_name         = "rds"
  environment           = "test"
  label_order           = ["environment", "name"]
  master_password       = "test123456"
  instance_class        = "db.t3.medium"
  cluster_size          = 1
}

  ```
### Secure Example
```hcl
module "documentdb" {
  source = "clouddrove/terraform-aws-documentdb/aws"
  name                    = "documentdb"
  environment             = "test"
  label_order             = ["environment", "name"]
  vpc_id                  = module.vpc.vpc_id
  subnet_list             = module.subnets.private_subnet_id
  vpc_security_group_ids  = [module.security_group-documentdb.security_group_ids]
  database_name           = "test"
  skip_final_snapshot     = false
  storage_encrypted       = true
  kms_key_id              = module.kms_key.key_arn
  tls_enabled             = true
  instance_class          = "db.t3.medium"
  cluster_size            = 2
  deletion_protection     = true
  preferred_backup_window = "07:00-07:30"
}

  ```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. | `string` | `"true"` | no |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| cluster\_family | The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html . | `string` | `"docdb4.0"` | no |
| cluster\_size | Number of DB instances to create in the cluster | `string` | `"2"` | no |
| database\_name | Name of the database. | `string` | n/a | yes |
| deletion\_protection | (optional) describe your variable | `bool` | `null` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery. | `list(string)` | `[]` | no |
| engine | The name of the database engine to be used for this DB cluster. Defaults to `docdb`. Valid values: `docdb`. | `string` | `"docdb"` | no |
| engine\_version | The version number of the database engine to use. | `string` | `""` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| instance\_class | The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs . | `string` | `"db.t3.medium"` | no |
| kms\_key\_id | The ARN for the KMS encryption key. When specifying `kms_key_id`, `storage_encrypted` needs to be set to `true`. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove' | `string` | `"hello@clouddrove.com"` | no |
| master\_password | (Required unless a snapshot\_identifier is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. | `string` | `""` | no |
| master\_username | (Required unless a snapshot\_identifier is provided) Username for the master DB user. | `string` | `"root"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| port | Open port in sg for db communication. | `number` | `27017` | no |
| preferred\_backup\_window | Daily time range during which the backups happen. | `string` | `"07:00-09:00"` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-documentdb"` | no |
| retention\_period | Number of days to retain backups for. | `string` | `"7"` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `string` | `"false"` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot. | `string` | `""` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted. | `string` | `"false"` | no |
| subnet\_list | List of subnet IDs database instances should deploy into. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| tls\_enabled | When true than cluster using TLS for communication. | `bool` | `false` | no |
| vpc\_id | ID of the VPC to deploy database into. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the cluster. |
| cluster\_name | Cluster Identifier. |
| master\_password | password for the master DB user. |
| master\_username | Username for the master DB user. |
| reader\_endpoint | A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas. |
| writer\_endpoint | Endpoint of the DocumentDB cluster. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-documentdb/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-documentdb)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
