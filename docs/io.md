## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. | `bool` | `true` | no |
| ca\_cert\_identifier | The identifier of the certificate authority (CA) certificate for the DB instance. | `string` | `null` | no |
| cluster\_family | The family of the DocumentDB cluster parameter group. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-parameter-group-create.html . | `string` | `"docdb5.0"` | no |
| cluster\_size | Number of DB instances to create in the cluster | `string` | `"2"` | no |
| database\_name | Name of the database. | `string` | n/a | yes |
| deletion\_protection | (optional) describe your variable | `bool` | `null` | no |
| enable | Flag to control the documentDB creation. | `bool` | `true` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery. | `list(string)` | <pre>[<br>  "audit",<br>  "profiler"<br>]</pre> | no |
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
| parameters | A list of DocumentDB parameters to apply. Setting parameters to system default values may show a difference on imported resources. | <pre>list(object({<br>    apply_method = optional(string)<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| preferred\_backup\_window | Daily time range during which the backups happen. | `string` | `"07:00-09:00"` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-documentdb"` | no |
| retention\_period | Number of days to retain backups for. | `string` | `"7"` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `bool` | `false` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot. | `string` | `""` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted. | `bool` | `true` | no |
| subnet\_list | List of subnet IDs database instances should deploy into. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| vpc\_security\_group\_ids | n/a | `set(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the cluster. |
| cluster\_name | Cluster Identifier. |
| master\_password | password for the master DB user. |
| master\_username | Username for the master DB user. |
| reader\_endpoint | A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas. |
| writer\_endpoint | Endpoint of the DocumentDB cluster. |

