. /vagrant_config/install.env

echo "******************************************************************************"
echo "Create database." `date`
echo "******************************************************************************"

echo "ORACLE_SID    - ${ORACLE_SID}~"
echo "DB_NAME       - ${DB_NAME}~"
echo "DB_DOMAIN_STR - ${DB_DOMAIN_STR}~"                                       
echo "SYS_PASSWORD  - ${SYS_PASSWORD}~"                                              
echo "PDB_NAME      - ${PDB_NAME}~"                                                      
echo "PDB_PASSWORD  - ${PDB_PASSWORD}~"                                        
echo "DATA_DIR      - ${DATA_DIR}~"                                        
echo "DB_NAME       - ${DB_NAME}~"
echo "NODE1_DB_UNIQUE_NAME - ${NODE1_DB_UNIQUE_NAME}~"   

dbca -silent -createDatabase                                                 \
  -templateName General_Purpose.dbc                                          \
  -sid ${ORACLE_SID}                                                         \
  -responseFile NO_VALUE                                                     \
  -gdbname ${DB_NAME}${DB_DOMAIN_STR}                                        \
  -characterSet AL32UTF8                                                     \
  -sysPassword ${SYS_PASSWORD}                                               \
  -systemPassword ${SYS_PASSWORD}                                            \
  -createAsContainerDatabase true                                            \
  -numberOfPDBs 1                                                            \
  -pdbName ${PDB_NAME}                                                       \
  -pdbAdminPassword ${PDB_PASSWORD}                                          \
  -databaseType MULTIPURPOSE                                                 \
  -automaticMemoryManagement false                                           \
  -totalMemory 2048                                                          \
  -storageType FS                                                            \
  -datafileDestination "${DATA_DIR}"                                         \
  -redoLogFileSize 50                                                        \
  -emConfiguration NONE                                                      \
  -initparams db_name=${DB_NAME},db_unique_name=${NODE1_DB_UNIQUE_NAME}      \
  -useOMF false                                                              \
  -ignorePreReqs

exit

echo "******************************************************************************"
echo "Set the PDB to auto-start." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
ALTER SYSTEM SET db_create_file_dest='${DATA_DIR}';
ALTER SYSTEM SET db_create_online_log_dest_1='${DATA_DIR}';
ALTER PLUGGABLE DATABASE ${PDB_NAME} SAVE STATE;
ALTER SYSTEM RESET local_listener;
exit;
EOF

echo "******************************************************************************"
echo "Configure archivelog mode, standby logs and flashback." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_BASE}/fast_recovery_area

sqlplus / as sysdba <<EOF

-- Set recovery destination.
alter system set db_recovery_file_dest_size=20G SCOPE=BOTH;
alter system set db_recovery_file_dest='${ORACLE_BASE}/fast_recovery_area' SCOPE=BOTH;

-- Enable archivelog mode.
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

ALTER DATABASE FORCE LOGGING;
-- Make sure at least one logfile is present.
ALTER SYSTEM SWITCH LOGFILE;

-- Add standby logs.
--ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 10 SIZE 50M;
--ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 11 SIZE 50M;
--ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 12 SIZE 50M;
--ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 13 SIZE 50M;
-- If you don't want to use OMF specify a path like this.
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 11 ('${DATA_DIR}/${ORACLE_SID^^}/standby_redo01.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 12 ('${DATA_DIR}/${ORACLE_SID^^}/standby_redo02.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 13 ('${DATA_DIR}/${ORACLE_SID^^}/standby_redo03.log') SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 14 ('${DATA_DIR}/${ORACLE_SID^^}/standby_redo04.log') SIZE 50M;

-- Enable flashback database.
ALTER DATABASE FLASHBACK ON;

ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO SCOPE=BOTH;
EXIT;
EOF



echo "******************************************************************************"
echo "Enable the broker." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF

ALTER SYSTEM SET dg_broker_start=TRUE SCOPE=BOTH;

EXIT;
EOF
