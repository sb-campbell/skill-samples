# Auto Scaling Group with Rolling Deploy 

This folder contains an example [Terraform](https://www.terraform.io/) configuration that defines a module for deploying a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto Scaling](https://aws.amazon.com/autoscaling/)) in an [Amazon Web Services (AWS)](http://aws.amazon.com/) account.

The Auto Scaling Group is able to do a zero-downtime deployment (using [instance refresh](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html)) when any of its properties are updated. 
