# MySQL example

This folder contains a [Terraform](https://www.terraform.io/) configuration that shows an example of how to use the [mysql module](../../modules/data-stores/mysql) to deploy a MySQL database (using [RDS](https://aws.amazon.com/rds/) in an [Amazon Web Services (AWS)](http://aws.amazon.com/) account.

#### Pre-requisites

Configure [AWS access keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as environment variables:

```
export AWS_ACCESS_KEY_ID=(access key id)
export AWS_SECRET_ACCESS_KEY=(secret access key)
```

Configure the database credentials as environment variables:

```
export TF_VAR_db_username=(database username)
export TF_VAR_db_password=(database password)
```
