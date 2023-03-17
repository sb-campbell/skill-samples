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

Execute the following to deploy a functioning Data Guard installation...

Start the first node (primary database) and wait for it to complete...

```
cd node1
vagrant up
```

Start the second node (standby database with configured DataGuard broker) and wait for it to complete...

```
cd ../node2
vagrant up
```

## Turn Off or Destroy the System

Execute the following to cleanly shutdown or destroy the system...

```
cd ../node2
vagrant halt {or} destroy

cd ../node1
vagrant halt {or} destroy
```
