#!/bin/bash
# Copyright:
# Author: Shawn Campbell
# Description:  This script breaks up the ansible inventory files into multiple batches
#               for patching in groups
# Instructions: This script should be run locally

###################################
# Environment Variables
###################################

OUTDIR="./out"
WORKINGDIR="./working"

MYFILTER="mt01|mt03|mt05|mt07|mt51|mt91"

#-----------------------------------------------------------------------
#   Prod file update
#-----------------------------------------------------------------------
FILENAME="{prod_inventory_file}"
FILE="${OUTDIR}/${FILENAME}"
SAVEFILE="${WORKINGDIR}/${FILENAME}"

cp ${FILE} ${SAVEFILE}

# output headers for files and batch 1 phx prod
echo "[prod:children]
phx_prod
iad_prod
phx_other
iad_other

[phx_prod:children]
phx_prod_batch1
phx_prod_batch2
phx_prod_other

[iad_prod:children]
iad_prod_batch1
iad_prod_batch2
iad_prod_other

[phx_prod_batch1] " > ${FILE}
grep -E  "${MYFILTER}" ${SAVEFILE} | grep phx  |grep ipp >> ${FILE}

#   phx prod batch 2 odd number
echo "

[phx_prod_batch2] " >> ${FILE}
grep -E -v "${MYFILTER}" ${SAVEFILE} | grep phx  |grep ipp >> ${FILE}

#   phx other 
echo "

[phx_prod_other] "  >> ${FILE}
grep -E  "{subnet_1st_3_octets}" ${SAVEFILE} | grep -v phx  >> ${FILE}

#   iad prod batch 1 odd number
echo "

[iad_prod_batch1] " >> ${FILE}
grep -E  "${MYFILTER}" ${SAVEFILE} | grep iad  |grep ipp >> ${FILE}


#   iad prod batch 2 odd number
echo "

[iad_prod_batch2] " >> ${FILE}
grep -E -v "${MYFILTER}" ${SAVEFILE} | grep iad  |grep ipp >> ${FILE}

#   iad other 
echo "

[iad_prod_other] "  >> ${FILE}
grep -E  "{subnet_1st_3_octets}" ${SAVEFILE} | grep -v iad  >> ${FILE}

echo "

" >>${FILE}

#-----------------------------------------------------------------------
#   Stage file update
#-----------------------------------------------------------------------

FILENAME="{stage_inventory_file}"
FILE="${OUTDIR}/${FILENAME}"
SAVEFILE="${WORKINGDIR}/${FILENAME}"

cp ${FILE} ${SAVEFILE}

echo "[stage:children]
phx_stage
iad_stage

[phx_stage:children]
phx_stage_batch1
phx_stage_batch2
phx_stage_other

[iad_stage:children]
iad_stage_batch1
iad_stage_batch2
iad_stage_other


[phx_stage_batch1] " > ${FILE}
grep -E  "${MYFILTER}" ${SAVEFILE} | grep phx  |grep iss >> ${FILE}

echo "

[phx_stage_batch2] " >> ${FILE}
grep -E -v "${MYFILTER}" ${SAVEFILE} | grep phx  |grep iss >> ${FILE}

#   phx other 
echo "

[phx_stage_other] "  >> ${FILE}
grep -E  "{subnet_1st_3_octets}" ${SAVEFILE} | grep -v phx  >> ${FILE}

echo "

[iad_stage_batch1] " >> ${FILE}
grep -E  "${MYFILTER}" ${SAVEFILE} | grep iad  |grep iss >> ${FILE}

echo "

[iad_stage_batch2] " >> ${FILE}
grep -E -v "${MYFILTER}" ${SAVEFILE} | grep iad  |grep iss >> ${FILE}

#   iad other 
echo "

[iad_stage_other] "  >> ${FILE}
grep -E  "{subnet_1st_3_octets}" ${SAVEFILE} | grep -v iad  >> ${FILE}

echo "

" >>${FILE}


