#!/bin/bash
# Copyright:
# Author: Shawn Campbell
# Description:  Utilize OCI CLI to query multiple tenancies and compartments for 
#               compute host inventories. Output is parsed into ssh config files,
#               ansible inventory files, and /etc/hosts resolution files
# Instructions: This script should be run locally and your oci credentials should be
#               pre-configured
#
# NOTE!!! PRIOR TO EXECUTION...
#               Verify that 'compartment-id' for each profile in your
#               ~/.oci/{tenancy/account resource config} specifies the root 
#               compartment OCID

###################################
# Environment Variables
###################################

SCRIPT=`basename $0`
BASE_DIR=`dirname $0`
WORKING_DIR="${BASE_DIR}/working"
OUTPUT_DIR="${BASE_DIR}/out"
TEMPLATES_DIR="${BASE_DIR}/templates"

echo "Script name is: ${SCRIPT}, running from directory: ${BASE_DIR}, output dir is: ${OUTPUT_DIR}"

PROD_TENANCY={prod_tenancy}
STAGE_TENANCY={stage_tenancy}
ENVIRONMENTS="PROD STAGE"
REGIONS="PHX IAD"

PROD_ROOT_COMPARTMENT_OCID="{ocid}"
STAGE_ROOT_COMPARTMENT_OCID="{ocid}"

###################################
# Functions
###################################

# get_oci_command - build the basic syntax for the OCI CLI call
get_oci_command () {
  MYENVIRONMENT=$1
  MYREGION=$2
  OCICOMMAND="oci --config-file ~/.oci/config --profile ${MYENVIRONMENT}${MYREGION} --cli-rc-file ~/.oci/{tenancy/account resource config}"
}

###################################
# Get compartment lists...
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  echo "Compartments in ${ENVIRONMENT}"

  COMPARTMENTS_FILE="${WORKING_DIR}/${ENVIRONMENT}_compartments.lst"
  if [ -f ${COMPARTMENTS_FILE} ] ; then
    rm ${COMPARTMENTS_FILE}
  fi

  # OCI CLI command...
  get_oci_command ${ENVIRONMENT} "PHX"
  ${OCICOMMAND} iam compartment list --query 'data[*].{"compartment-name":name,ocid:id}' --output table | tee ${COMPARTMENTS_FILE}

  echo ""

done

###################################
# Get compute instance lists...
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  for REGION in ${REGIONS}; do

    INSTANCES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_compute_instances.lst"
    rm ${INSTANCES_FILE}

    echo "# ${ENVIRONMENT}${REGION} compute instances" | tee ${INSTANCES_FILE}

    get_oci_command ${ENVIRONMENT} ${REGION}

    for COMPARTMENT_OCID in `grep ocid1 ${WORKING_DIR}/${ENVIRONMENT}_compartments.lst | cut -d "|" -f 3 | sed "s/ //g"`; do

      COMPARTMENT_NAME=`grep ${COMPARTMENT_OCID} ${WORKING_DIR}/${ENVIRONMENT}_compartments.lst | cut -d "|" -f 2 | sed "s/ //g"`

      echo "# Compute instances in ${ENVIRONMENT}${REGION} compartment ${COMPARTMENT_NAME}" | tee -a ${INSTANCES_FILE}

      # OCI CLI command...
      ${OCICOMMAND} compute instance list -c ${COMPARTMENT_OCID} --sort-by DISPLAYNAME --all --query 'data[?"lifecycle-state"==`RUNNING`].{"hostname":"display-name",ocid:id,"compartment-id":"compartment-id"}' --output table | tee -a ${INSTANCES_FILE}

    done

  done

done

###################################
# Get vnic lists...
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  for REGION in ${REGIONS}; do

    INSTANCES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_compute_instances.lst"

    VNICS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_vnics.lst"
    rm ${VNICS_FILE}

    get_oci_command ${ENVIRONMENT} ${REGION}

    echo "# VNICs in ${ENVIRONMENT}${REGION}" | tee -a ${VNICS_FILE}

    for HOST_OCID in `grep ocid1 ${INSTANCES_FILE} | cut -d "|" -f 4 | sed "s/ //g"`; do

      HOST_NAME=`grep ${HOST_OCID} ${INSTANCES_FILE} | cut -d "|" -f 3 | sed "s/ //g"`
      COMPARTMENT_OCID=`grep ${HOST_OCID} ${INSTANCES_FILE} | cut -d "|" -f 2| sed "s/ //g"`

      echo "# Querying VNICs for ${HOST_NAME}"

      # OCI CLI command...
      ${OCICOMMAND} compute instance list-vnics -c ${COMPARTMENT_OCID} --instance-id ${HOST_OCID} --query 'data[*].{"private-ip":"private-ip","public-ip":"public-ip","display-name":"display-name","hostname-label":"hostname-label","subnet-ocid":"subnet-id"}' --output table | tee -a ${VNICS_FILE}
     
    done

    echo "" | tee -a ${INSTANCES_FILE}

  done

done

###################################
# Get subnet lists...
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  for REGION in ${REGIONS}; do

    SUBNETS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_subnets.lst"
    rm ${SUBNETS_FILE}

    echo "# ${ENVIRONMENT}${REGION} subnets" | tee ${SUBNETS_FILE}

    get_oci_command ${ENVIRONMENT} ${REGION}

    for COMPARTMENT_OCID in `grep ocid1 ${WORKING_DIR}/${ENVIRONMENT}_compartments.lst | cut -d "|" -f 3 | sed "s/ //g"`; do

      COMPARTMENT_NAME=`grep ${COMPARTMENT_OCID} ${WORKING_DIR}/${ENVIRONMENT}_compartments.lst | cut -d "|" -f 2 | sed "s/ //g"`

      echo "# Subnets in ${ENVIRONMENT}${REGION} compartment ${COMPARTMENT_NAME}" | tee -a ${SUBNETS_FILE}

      # OCI CLI command...
      ${OCICOMMAND} network subnet list -c ${COMPARTMENT_OCID} --query 'data[*].{"display-name":"display-name","ocid":"id","dns-label":"dns-label","subnet-domain-name":"subnet-domain-name"}' --output table | tee -a ${SUBNETS_FILE}

    done

    echo "" | tee -a ${SUBNETS_FILE}

  done

  # Get any subnets in root compartment
  if [ ${ENVIRONMENT} == "PROD" ]
  then
    COMPARTMENT_OCID=${PROD_ROOT_COMPARTMENT_OCID}
  else
    COMPARTMENT_OCID=${STAGE_ROOT_COMPARTMENT_OCID}
  fi
  echo "# Subnets in ${ENVIRONMENT} compartment Root - ${COMPARTMENT_OCID}" | tee -a ${SUBNETS_FILE}
  ${OCICOMMAND} network subnet list -c ${COMPARTMENT_OCID} --query 'data[*].{"display-name":"display-name","ocid":"id","dns-label":"dns-label","subnet-domain-name":"subnet-domain-name"}' --output table | tee -a ${SUBNETS_FILE}

done

###################################
# Get image lists...
###################################
#
# for ENVIRONMENT in ${ENVIRONMENTS}; do
# 
#   COMPARTMENT_OCID=`grep ocid1 ${WORKING_DIR}/${ENVIRONMENT}_compartments.lst | grep OS_Images | cut -d "|" -f 3 | sed "s/ //g"`
# 
#   for REGION in ${REGIONS}; do
# 
#     IMAGES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_images.lst"
#     echo "# ${ENVIRONMENT}${REGION} images" | tee ${IMAGES_FILE}
# 
#     get_oci_command ${ENVIRONMENT} ${REGION}
# 
#     # OCI CLI command...
#     ${OCICOMMAND} compute image list -c ${COMPARTMENT_OCID} --query 'data[*].{"display-name":"display-name","ocid":"id","operating-system":"operating-system","operating-system-version":"operating-system-version"}' --all --output table | tee -a ${IMAGES_FILE}
# 
#   done
# 
#   echo "" | tee -a ${IMAGES_FILE}
# 
# done

###################################
# Create the hosts file
###################################

HOSTS_FILE="${OUTPUT_DIR}/hosts"
rm ${HOSTS_FILE}

for ENVIRONMENT in ${ENVIRONMENTS}; do

  COMPARTMENTS_FILE="${WORKING_DIR}/${ENVIRONMENT}_compartments.lst"

  for REGION in ${REGIONS}; do

    echo "# ${ENVIRONMENT} ${REGION}" | tee -a ${HOSTS_FILE}

    INSTANCES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_compute_instances.lst"
    VNICS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_vnics.lst"
    SUBNETS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_subnets.lst"

    for INSTANCE_OCID in `grep ocid1 ${INSTANCES_FILE} | cut -d "|" -f 4 | sed "s/ *//g"`; do
      INSTANCE_SHORT_HOSTNAME=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 3 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_OCID=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_NAME=`grep ${INSTANCE_COMPARTMENT_OCID} ${COMPARTMENTS_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`

      if [[ ${INSTANCE_COMPARTMENT_NAME} == "Active-Directory" ]] || [[ ${INSTANCE_COMPARTMENT_NAME} == "OKE" ]] ; then
        continue
      fi

      INSTANCE_INTERNAL_IP=`grep ocid1 ${VNICS_FILE} | grep ${INSTANCE_SHORT_HOSTNAME} | cut -d "|" -f 4 | sed "s/ *//g"`
      INSTANCE_SUBNET_OCID=`grep ${INSTANCE_SHORT_HOSTNAME} ${VNICS_FILE} | cut -d "|" -f 6 | sed "s/ *//g"`
      INSTANCE_SUBNET_DOMAIN=`grep ${INSTANCE_SUBNET_OCID} ${SUBNETS_FILE} | cut -d "|" -f 5 | sed "s/ *//g"`

      echo "${INSTANCE_INTERNAL_IP}   ${INSTANCE_SHORT_HOSTNAME}.${INSTANCE_SUBNET_DOMAIN}   ${INSTANCE_SHORT_HOSTNAME}" | tee -a ${HOSTS_FILE}

    done

    echo "" | tee -a ${HOSTS_FILE}

  done

done

###################################
# Create the ansible inventory files
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  ANSIBLE_FILE="${OUTPUT_DIR}/oci_idm_${ENVIRONMENT,,}"
  rm ${ANSIBLE_FILE}

  echo "[${ENVIRONMENT,,}:children]" | tee -a ${ANSIBLE_FILE}
  echo "phx_${ENVIRONMENT,,}" | tee -a ${ANSIBLE_FILE}
  echo "iad_${ENVIRONMENT,,}" | tee -a ${ANSIBLE_FILE}
  echo "" | tee -a ${ANSIBLE_FILE}

  COMPARTMENTS_FILE="${WORKING_DIR}/${ENVIRONMENT}_compartments.lst"

  for REGION in ${REGIONS}; do

    echo "[${REGION,,}_${ENVIRONMENT,,}]" | tee -a ${ANSIBLE_FILE}

    INSTANCES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_compute_instances.lst"
    VNICS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_vnics.lst"
#    SUBNETS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_subnets.lst"

    for INSTANCE_OCID in `grep ocid1 ${INSTANCES_FILE} | cut -d "|" -f 4 | sed "s/ *//g"`; do
      INSTANCE_SHORT_HOSTNAME=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 3 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_OCID=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_NAME=`grep ${INSTANCE_COMPARTMENT_OCID} ${COMPARTMENTS_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`

      if [[ ${INSTANCE_COMPARTMENT_NAME} == "Active-Directory" ]] || [[ ${INSTANCE_COMPARTMENT_NAME} == "OKE" ]] || [[ ${INSTANCE_COMPARTMENT_NAME} == "Networks-JumpVCN" ]] ; then
        continue
      fi

      INSTANCE_INTERNAL_IP=`grep ocid1 ${VNICS_FILE} | grep ${INSTANCE_SHORT_HOSTNAME} | cut -d "|" -f 4 | sed "s/ *//g"`
#      INSTANCE_SUBNET_OCID=`grep ${INSTANCE_SHORT_HOSTNAME} ${VNICS_FILE} | cut -d "|" -f 6 | sed "s/ *//g"`
#      INSTANCE_SUBNET_DOMAIN=`grep ${INSTANCE_SUBNET_OCID} ${SUBNETS_FILE} | cut -d "|" -f 5 | sed "s/ *//g"`

      echo "${INSTANCE_SHORT_HOSTNAME} ansible_host=${INSTANCE_INTERNAL_IP}" | tee -a ${ANSIBLE_FILE}

    done

    echo "" | tee -a ${ANSIBLE_FILE}

  done

done

###################################
# Create the ssh config files
###################################

for ENVIRONMENT in ${ENVIRONMENTS}; do

  COMPARTMENTS_FILE="${WORKING_DIR}/${ENVIRONMENT}_compartments.lst"

  if [[ ${ENVIRONMENT} == "PROD" ]] ; then
    TENANCY=${PROD_TENANCY}
  else
    TENANCY=${STAGE_TENANCY}
  fi
 
  for REGION in ${REGIONS}; do

    TEMPLATE_FILE="${TEMPLATES_DIR}/${TENANCY}_${REGION,,}_template"
    SSH_CONFIG_FILE="${OUTPUT_DIR}/${TENANCY}_${REGION,,}"
    rm ${SSH_CONFIG_FILE}

    JUMP_HOSTS=`grep Host ${TEMPLATE_FILE} | grep jmpmt | cut -d " " -f 2 | sort -u | xargs`
    JUMP_HOST_1=`echo "${JUMP_HOSTS}" | cut -d " " -f 1`
    JUMP_HOST_2=`echo "${JUMP_HOSTS}" | cut -d " " -f 2`

    cat ${TEMPLATE_FILE} | tee ${SSH_CONFIG_FILE}
    chmod 600 ${SSH_CONFIG_FILE}

    INSTANCES_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_compute_instances.lst"
    VNICS_FILE="${WORKING_DIR}/${ENVIRONMENT}${REGION}_vnics.lst"

    for INSTANCE_OCID in `grep ocid1 ${INSTANCES_FILE} | cut -d "|" -f 4 | sed "s/ *//g"`; do
      INSTANCE_SHORT_HOSTNAME=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 3 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_OCID=`grep ${INSTANCE_OCID} ${INSTANCES_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`
      INSTANCE_COMPARTMENT_NAME=`grep ${INSTANCE_COMPARTMENT_OCID} ${COMPARTMENTS_FILE} | cut -d "|" -f 2 | sed "s/ *//g"`

      if [[ ${INSTANCE_COMPARTMENT_NAME} == "Active-Directory" ]] || [[ ${INSTANCE_COMPARTMENT_NAME} == "OKE" ]] || [[ ${INSTANCE_COMPARTMENT_NAME} == "Networks-JumpVCN" ]] ; then
        continue
      fi

      INSTANCE_INTERNAL_IP=`grep ocid1 ${VNICS_FILE} | grep ${INSTANCE_SHORT_HOSTNAME} | cut -d "|" -f 4 | sed "s/ *//g"`

      echo "Host ${INSTANCE_SHORT_HOSTNAME} ${INSTANCE_INTERNAL_IP}" | tee -a ${SSH_CONFIG_FILE}
      echo "    Hostname ${INSTANCE_INTERNAL_IP}" | tee -a ${SSH_CONFIG_FILE}
      echo "    ProxyCommand /bin/sh -c 'ssh -q -W %h:%p ${JUMP_HOST_1} || ssh -q -W %h:%p ${JUMP_HOST_2}'" | tee -a ${SSH_CONFIG_FILE}

      if [[ ${INSTANCE_SHORT_HOSTNAME} == *"auto"* ]]; then
        echo "    RemoteForward 2222 {bastion_fqdn}:22" | tee -a ${SSH_CONFIG_FILE}
      fi

      echo "" | tee -a ${SSH_CONFIG_FILE}

    done

  done
  
done
