# Architecture

- Bash shell script
- Oracle SQL
- LDAP (ldapsearch, ldapmodify)
- sudo

# Purpose

Sudo policies in LDAP for sudoHost authorization... 

This script queries lists of hosts from the LOB's host/asset inventory database using varying criteria and adds the hosts to the 'sudoHost' list in LDAP for the relevant sudo policy.

# Potential Enhancements

- Test and verify DB and LDAP connectivity
  - optionally, email admins if connectivity issues
- Add command-line switch options to execute each section in isolation - Script has 3 basic sections... (1) query DB and gather host list, (2) format LDIF, (3) apply LDIF to LDAP servers (suppliers)
- Obfuscate DB and LDAP usernames and passwords using a wallet encryption tool such as walletMgr

# File Tree

```
.
├── README.md
├── config.conf
├── ldif/
├── log/
├── policy_hosts_inventory.sh
├── sql/
│   ├── sample_nonprod1_policy_hosts.sql
│   ├── sample_nonprod2_policy_hosts.sql
│   ├── sample_prod1_policy_hosts.sql
│   └── sample_prod2_policy_hosts.sql
└── sql_output/
```
# Sample cron entries

```
\# Sudo policy host lists - 1 entry per policy
05 * * * * /u01/{script path}/policy_hosts_inventory.sh {policy1} >/dev/null 2>&1
35 * * * * /u01/{script path}/policy_hosts_inventory.sh {policy2} >/dev/null 2>&1
```
# Sample Oracle database TNS config

```
{SID} =
  (DESCRIPTION =
    (ADDRESS=(PROTOCOL=TCP)(HOST={Oracle DB Hostname})(PORT=1521))
    (CONNECT_DATA= 
      (SERVER = DEDICATED)
      (SERVICE_NAME = {SID})
    )
)
```

