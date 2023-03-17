# ASG example

This folder contains a [Terraform](https://www.terraform.io/) configuration that shows an example of how to use the [asg-rolling-deploy](../../modules/cluster/asg-rolling-deploy) module to deploy a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto Scaling](https://aws.amazon.com/autoscaling/)) in an [Amazon Web Services (AWS)](http://aws.amazon.com/) account. 

#### Pre-requisites

Configure [AWS access keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as environment variables:

```
export AWS_ACCESS_KEY_ID=(access key id)
export AWS_SECRET_ACCESS_KEY=(secret access key)
```
