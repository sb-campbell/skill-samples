#!/bin/bash
# Copyright:
# Author: Shawn Campbell
# Description:  Build list of target hosts by policy from LOB asset inventory database
#               and load them into the relevant sudoers policy entry in LDAP
# Instructions: This script should only be run on {...} host in {...} environment
#               as it needs to have connectivity to both the LDAP supplier and the 
#               LOB's asset inventory database

##############
# Environment Variables
##############

unset JAVA_HOME
export PATH={path to local perl}:{path to local openLDAP binaries}:{path to team common scripts}:${PATH}
export HOME=/u01/{team_home_dir}/
export LDAPCONF=${HOME}/.ldaprc      # LDAP config file
export LDAPRC=${HOME}/.ldaprc        # LDAP config file

export ORACLE_HOME=/u01/{path to Oracle binaries}/instantclient_12_2/
export TNS_ADMIN=/u01/{path to local Oracle tnsnames.ora}/
export PATH=${ORACLE_HOME}:${TNS_ADMIN}::$PATH
export LD_LIBRARY_PATH=/u01/{path to Oracle libraries}/

##############
# Logging and Script Variables
##############

RUNDATE=`date +%Y%m%dT%H%M`   # ISO 19951231T235959
SCRIPTNAME=`basename $0`
BASE_DIR=${dirname "$0"}

LOG_DIR=${BASE_DIR}/log
LDIF_DIR=${BASE_DIR}/ldif
SQL_DIR=${BASE_DIR}/sql
SQL_OUTPUT_DIR=${BASE_DIR}/sql_output

CONFIG_FILE="/u01/{path to DB config file}/{db config file}.conf"
SPOOL_FILE="${SQL_OUTPUT_DIR}/${POLICY_NAME}_hosts.lst"              # policy hosts list
LDIF_FILE="${LDIF_DIR}/${POLICY_NAME}_modify.ldif"                   # formatted ldap .ldif file
BACKUP_LDIF_FILE="${LDIF_DIR}/${POLICY_NAME}_${RUNDATE}.ldif"        # backup copy of ldap policy entry in .ldif format

##############
# check policy argument or USAGE
##############

if [ -z "${1}" ]
  then
    echo ""
    echo "Please specify policy!"
    echo ""
    exit
  else
    POLICY_NAME=${1}
fi

LOGGIT="${LOG_DIR}/${SCRIPTNAME}-${POLICY_NAME}.log"

##############
# configure DB connectivity
##############

DATABASE_USER=`egrep db_user $CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`
DATABASE_INSTANCE=`egrep db_svc $CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`
DATABASE_USER_PASSWORD=`egrep db_pass $CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`

##############
# configure LDAP connectivity
##############

LDAP_SERVER=`egrep ldap_server CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`
LDAP_USER=`egrep ldap_user CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`
LDAP_PASSWORD_FILE=`egrep ldap_password_file CONFIG_FILE|awk -F= '{print $2}'|sed -e's/\"//g'`

##############
# functions
##############

# Run the sql script to create the list of hosts and direct to an output file
DB_Query () {
  sqlplus -S /nolog << EOF
    CONNECT ${DATABASE_USER}/${DATABASE_USER_PASSWORD}@${DATABASE_INSTANCE};
    whenever sqlerror exit sql.sqlcode;
    set pagesize 9999
    set feedback off
    set echo off
    set heading off
    set autoprint off
    set termout off
    set serveroutput off

    spool ${SPOOL_FILE} 

    @${SQL_DIR}/${POLICY_NAME}_hosts.sql

    exit;
EOF
}

# Parse output file and start generating an ldif to insert them into the LDAP directory
Create_LDIF () {
  (
  echo dn: cn=$POLICY_NAME,ou=sudoers,dc={domain},dc=com
  echo changetype: modify
  echo replace: sudoHost

  # Generate parsed list of target hosts
  for INVENTORY_HOSTNAME in `egrep -v "rows selected" ${SPOOL_FILE}|sort -u`
  do
    echo sudoHost: ${INVENTORY_HOSTNAME}
  done
  ) > ${LDIF_FILE}
}

# Load hosts into LDAP
Add_SudoHosts () {
  # Create backup of sudoers policy entry
  /usr/bin/ldapsearch -LLL -x -H ldaps://${LDAP_SERVER} -o ldif-wrap=1000 -D "cn=Directory Manager" -b ou=sudoers,dc={domain},dc=com -y ${LDAP_PASSWORD_FILE} cn=${POLICY_NAME} > ${BACKUP_LDIF_FILE}

  # Insert new set of sudoHost values
  /usr/bin/ldapmodify -x -H ldaps://${LDAP_SERVER} -D "cn=Directory Manager" -y ${LDAP_PASSWORD_FILE} -v -c -f ${LDIF_FILE}
}

##############
# main
##############

# Log everything.
(
echo "script started at $RUNDATE"

echo "Before DB_Query"
DB_Query

echo "Before Create_LDIF"
Create_LDIF

echo "Before Add_SudoHosts"
Add_SudoHosts

echo script finished at `date +%Y%m%dT%H%M`
) > $LOGGIT 2>&1
