# Shawn Campbell - Sample Skills Repository

A sampling of projects which represent my work and skills in the relevant areas. See local README.md file in each project folder for full details of the project and potential enhancements.

### [Terraform & AWS (ALB, Listener, SGs, ASG, EC2s)](./terraform-aws/)

This project demonstrates the utilization of Terraform 'Infrastructure as Code' (IaC) for the deployments to AWS of an RDS MySQL database, ELB application load balancer and listener, EC2 auto-scaling group, and associated security groups.

### [Cloud (OCI) CLI - Compute Inventory Queries](./cloud-oci-cli/)

This project demonstrates utilization of the OCI Cloud CLI to extract current compute instance inventories by tenancy and compartment including hostnames, associated VNICs, IPs, subnets and domains.

### [Bash, Vagrant, VirtualBox, Oracle RDBMS (dual-node Data Guard Physical Stand-by Databases)](./bash-oracle-vagrant/)

This project demonstrates the utilization of Vagrant to create a local dual-node VirtualBox VM cluster hosting Oracle databases in a Data Guard physical standby configuration.  

### [Ansible, Bash, .j2 templates for sssd.conf and sudo_ldap.conf](./ansible-ldap-sssd-sudo/)

This project demonstrates the utilization of Ansible, .j2 templates (sssd.conf, sudo_ldap.conf, nsswitch, etc.) and Bash shell scripts to configure authN/AuthZ services on Linux clients to utilize LDAP, Sudo_LDAP and authentication automation using LDAP stored ssh public keys.

### [Bash, Oracle (SQL), LDAP, Sudo](./bash-sql-ldap-sudo/)

This is an ETL project which demonstrates the use of bash shell scripting, SQL queries against an Oracle database, transformation of result-sets, and integration with LDAP (ldapsearch and ldapmodify) in order to modify host-based access authorization policies for sudo (sudoers).

### To-Dos...

- python, rest - emds assetloader
- bash - Kevin's pb log analysis script
- perl - original assetloader script
