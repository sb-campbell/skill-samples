# Vagrant and Bash Automation to Deploy an Oracle 19c Data Guard Dual VM/Node Standby Database Cluster on VirtualBox

### Purpose/Objective

This is a sophisticated build which automates the deployment of a local 2-node VM test environment to host an Oracle 19c Data Guard standby database cluster. It is a Vagrant deployment of VirtualBox VMs using an Oracle Linux 8 box foundation ([vagrant box repo](https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=updated&provider=&q=bento%2Foracle)). 

### Credit

<<<<<<< HEAD
Thanks to [Tim Hall](https://oracle-base.com/misc/site-info) of [Oracle-Base.com](https://oracle-base.com) for both the inspiration and excellent training and foundation provided for this build...
=======
Thanks to [Tim Hall](https://oracle-base.com/misc/site-info)) of [Oracle-Base.com](https://oracle-base.com) for both the inspiration and excellent training and foundation provided for this build...
>>>>>>> c67000d79c9c7d37ab33d07ce1fa2a17ff740ea2

> [Data Guard Physical Standby Setup Using the Data Guard Broker in Oracle Database 19c](https://oracle-base.com/articles/19c/data-guard-setup-using-broker-19c)

### Architecture

* Vagrant
* Bash shell scripts
* VirtualBox

### Required Software

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- Oracle 19c database software... [Database LINUX.X64_193000_db_home.zip](https://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle19c-linux-5462157.html)

### Potential Enhancements

- Combine separate 2-node Vagrantfile(s) into single launch deployment using the sample methodology provided in 'Vagrantfile.gg'

### File Tree

```
.
├── README.md
├── Vagrantfile.gg
├── config
│   ├── install.env
│   └── vagrant.yml
├── node1
│   ├── Vagrantfile
│   └── scripts
│       ├── oracle_create_database.sh
│       ├── oracle_create_database_test1.sh
│       ├── oracle_user_environment_setup.sh
│       ├── root_setup.sh
│       └── setup.sh
├── node2
│   ├── Vagrantfile
│   └── scripts
│       ├── oracle_create_database.sh
│       ├── oracle_user_environment_setup.sh
│       ├── root_setup.sh
│       └── setup.sh
├── shared_scripts
│   ├── configure_chrony.sh
│   ├── configure_hostname.sh
│   ├── configure_hosts_base.sh
│   ├── install_os_packages.sh
│   ├── oracle_db_software_installation.sh
│   ├── oracle_software_patch.sh
│   └── prepare_u01_disk.sh
└── software
    ├── LINUX.X64_193000_db_home.zip -> /Volumes/Samsung_T5/dev-software/LINUX.X64_193000_db_home.zip
    ├── apex_22.2_en.zip -> /Volumes/Samsung_T5/dev-software/apex_22.2_en.zip
    └── put_software_here.txt
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
