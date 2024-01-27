#!/bin/bash
set -e

# /tmp/backup/YYYYMM/YYYYMMDD.sql.tar.gz に ファイルを mysqldump を保存する。

# env list
# DB_USER
# DB_PASS
# DB_HOST
# DB_NAME

YYYYMM=`date +%Y%m`
YYYYMMDD=`date +%Y%m%d`
echo "make YYYYMM directory"
mkdir -p "/tmp/backup/${YYYYMM}"

echo "mysqldump and output sql file"
/usr/bin/mysqldump --skip-column-statistics -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} > "/tmp/backup/${YYYYMM}/${YYYYMMDD}.sql"
cd /tmp/backup/${YYYYMM}

echo "compress sql file"
tar -zcvf ${YYYYMMDD}.sql.tar.gz ${YYYYMMDD}.sql

echo "remove raw dump file"
rm /tmp/backup/${YYYYMM}/${YYYYMMDD}.sql
