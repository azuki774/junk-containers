#!/bin/bash
set -e

# /backup/YYYYMM/YYYYMMDD.sql.tar.gz に ファイルを mysqldump を保存する。

# env list
# DB_USER
# DB_PASS
# DB_HOST
# DB_NAME

YYYYMM=`date +%Y%m`
YYYYMMDD=`date +%Y%m%d`
mkdir -p "/backup/${YYYYMM}"
/usr/bin/mysqldump --skip-column-statistics -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} > "/backup/${YYYYMM}/${YYYYMMDD}.sql"
cd /backup/${YYYYMM}
tar -zcvf ${YYYYMMDD}.sql.tar.gz ${YYYYMMDD}.sql
rm /backup/${YYYYMM}/${YYYYMMDD}.sql
