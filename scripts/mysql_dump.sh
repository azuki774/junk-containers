#!/bin/bash
set -e

### if FILE_NAME is not set
# /tmp/backup/YYYYMM/YYYYMMDD.sql.tar.gz に mysqldump を保存する。

### FILE_NAME is set
# /tmp/backup/${FILE_NAME}.sql.tar.gz に mysqldump を保存する。

# env list
# DB_USER
# DB_PASS
# DB_HOST
# DB_NAME
# FILE_NAME

YYYYMM=`date +%Y%m`
YYYYMMDD=`date +%Y%m%d`

FILE_DIR="/tmp/backup/"
if [ -z "${FILE_NAME}" ]; then
    FILE_NAME="${YYYYMMDD}"
    FILE_DIR="/tmp/backup/${YYYYMM}"
fi

echo "make YYYYMM directory"
mkdir -p ${FILE_DIR}

echo "mysqldump and output sql file"
/usr/bin/mysqldump --skip-column-statistics --single-transaction -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} > "${FILE_DIR}/${FILE_NAME}.sql"
cd ${FILE_DIR}

echo "compress sql file"
tar -zcvf ${FILE_NAME}.sql.tar.gz ${FILE_NAME}.sql

echo "remove raw dump file"
rm "${FILE_DIR}/${FILE_NAME}.sql"
