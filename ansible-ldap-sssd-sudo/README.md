# Ansible automation to configure authN/authZ on Linux clients

### Purpose/Objective

This is a series of Ansible scripts which configure authN/authZ functionality on clients.
1. direct client authN services to ldap: configure sssd, local ldap, and nsswitch
2. direct client authZ (sudo) services to ldap: certs, sudo-ldap.conf, and nsswitch
3. direct client ssh authorized_keys to ldap - allows users to store their workstation public ssh key in ldap and configured clients to utilize ldap to retrieve said key

### Architecture

- Ansible

### Potential Enhancements

- 'DRY' (Don't Repeat Yourself) - re-factor and store variables in inventory files or group_vars

### File Tree

```
.
├── README.md
├── group_files
│   ├── cacerts
│   │   └── cert.pem
│   ├── fix-local-999-group.sh
│   └── keyify
├── group_templates
│   ├── keyify.json.j2
│   ├── setup-netgroup-compat.sh.j2
│   ├── sssd.conf.j2
│   └── sudo-ldap.conf.j2
├── playbooks
│   ├── combined_sudo_ldap.yml
│   ├── keyify.yml
│   ├── ldapclient.yml
│   └── sudo_client_configure.yml
└── utility_scripts
    └── autonum_tasks
```
