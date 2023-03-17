# Shawn Campbell - Sample Skills Repository

A sampling of projects which represent my work and skills in the relevant areas. See local README.md file in each project folder for full details of the project and potential enhancements.

### [Terraform & AWS (ALB, Listener, SGs, ASG, EC2s)](./terraform-aws/)

This project demonstrates the utilization of Terraform 'Infrastructure as Code' (IaC) for the deployments to AWS of an RDS MySQL database, ELB application load balancer and listener, EC2 auto-scaling group, and associated security groups.

### [Cloud (OCI) CLI - Compute Inventory Queries](./cloud-oci-cli/)

This Bash script demonstrates utilization of the OCI Cloud CLI to extract current compute instance inventories by tenancy and compartment including hostnames, associated VNICs, IPs, subnets and domains.

The resulting JSON output is parsed using JQuery-like syntax and processed into double-proxied (2x bastion/jump hosts) SSH config files, ansible inventories and /etc/hosts configs.

### [Bash, Vagrant, VirtualBox, Oracle RDBMS (dual-node Data Guard Physical Stand-by Databases)](./bash-oracle-vagrant/)

This project demonstrates the utilization of Vagrant to create a local dual-node VirtualBox VM cluster hosting Oracle databases in a Data Guard physical standby configuration.  

### [Bash, Oracle (SQL), LDAP, Sudo](./bash-sql-ldap-sudo/)

This is an ETL project which demonstrates the use of bash shell scripting, SQL queries against an Oracle database, transformation of result-sets, and integration with LDAP (ldapsearch and ldapmodify) in order to modify host-based access authorization policies for sudo (sudoers).

### To-Dos...

- python, rest - emds assetloader
- ansible project
- bash - Kevin's pb log analysis script
- perl - original assetloader script
