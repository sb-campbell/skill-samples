# Terraform IaC Deployment to AWS

### Purpose/Objective

This is a Terraform 'Infrastructure as Code' (IaC) for the deployments to AWS of an RDS MySQL database, ELB application load balancer and listener, EC2 auto-scaling group, and associated security groups. 

### Credit

Thanks to [Yevgeniy Brikman](https://www.ybrikman.com/) of [Gruntwork.io](https://www.gruntwork.io/?ref=ybrikman-home-header) for both the inspiration and excellent training and foundation provided for this build...

> [Terraform: Up & Running, 3rd Ed., 2022](https://www.terraformupandrunning.com/)

### Architecture

* Terraform
* AWS

### Required Software

- [Terraform](https://developer.hashicorp.com/terraform/downloads)

### Potential Enhancements

- Enhance 'Don't Repeat Yourself' (DRY) methodology by extracting numerous hard-coded values and local variables into .tfvars config file
- Integrate Terragrunt and/or Terratest to automate TF State management for multiple environmental deployments and for automated testing

### File Tree

```
.
├── README.md
├── examples                    # stand-alone module deployments
│   ├── alb
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── asg
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── mysql
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── live                        # full deployments in prod/stage environments
│   ├── prod
│   │   ├── data-stores
│   │   │   └── mysql
│   │   │       ├── README.md
│   │   │       ├── main.tf
│   │   │       ├── outputs.tf
│   │   │       └── variables.tf
│   │   └── services
│   │       └── hello-world-app
│   │           ├── README.md
│   │           ├── main.tf
│   │           ├── outputs.tf
│   │           └── variables.tf
│   └── stage
│       ├── data-stores
│       │   └── mysql
│       │       ├── README.md
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       └── variables.tf
│       └── services
│           └── hello-world-app
│               ├── README.md
│               ├── main.tf
│               ├── outputs.tf
│               └── variables.tf
└── modules                      # modules
    ├── cluster
    │   └── asg-rolling-deploy
    │       ├── README.md
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── data-stores
    │   └── mysql
    │       ├── README.md
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── networking
    │   └── alb
    │       ├── README.md
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    └── services
        └── hello-world-app
            ├── README.md
            ├── main.tf
            ├── outputs.tf
            ├── user-data.sh
            └── variables.tf
```

### Build Instructions

This project demonstrates the use of Terraform modules to deploy sets of AWS resources for multiple environments (ie. prod/stage). There are examples for either stand-alone builds or for the full environment.

**Stand-alone...**

Deploy the [RDS MySQL DB](./examples/mysql), [ALB](./examples/alb), and [ASG & EC2s](./examples/asg) individually per the instructions in each README.md

**Prod environment stack...**

Deploy the [RDS MySQL DB](./live/prod/data-stores/mysql), followed by the [ALB, listener, SGs, ASG and EC2s](./live/prod/services/hello-world-app) per the instructions in each README.md

**Stage environment stack...**

Deploy the [RDS MySQL DB](./live/stage/data-stores/mysql), followed by the [ALB, listener, SGs, ASG and EC2s](./live/stage/services/hello-world-app) per the instructions in each README.md
