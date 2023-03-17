# Cloud (OCI) CLI - Inventory of Compute Instance for SSH Configs, Ansible Inventories and /etc/hosts

### Purpose/Objective

This Bash script demonstrates utilization of the OCI Cloud CLI to extract current compute instance inventories by tenancy and compartment including hostnames, associated VNICs, IPs, subnets and domains. 

The resulting JSON output is parsed using JQuery-like syntax and processed into double-proxied (2x bastion/jump hosts) SSH config files, ansible inventories and /etc/hosts configs.

### Architecture

- OCI CLI/SDK installed as Python module using PIP
- Bash

### Required Software

- [OCI CLI/SDK](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm)

### Potential Enhancements

- Script should be re-factored to modularize the CLI calls

- Add 'Usage' option and checks for required OCI CLI environment config

- Potentially consider re-writing in Python so that the returned JSON data can be natively parsed as lists and dictionaries

### File Tree

```
.
├── README.md
├── batchify.sh
├── oci_inventory.sh
├── out
│   ├── ansible_inventory_prod
│   ├── ansible_inventory_stage
│   ├── hosts
│   ├── ssh_configs_prod_tenancy_region1
│   ├── ssh_configs_prod_tenancy_region2
│   ├── ssh_configs_stage_tenancy_region1
│   └── ssh_configs_stage_tenancy_region2
├── save
│   └── contains_backups_of_prior_iteration_output_files
├── templates
│   └── contains_ssh_config_header_templates
└── working
    └── contains_intermediate_cli_output_files
```