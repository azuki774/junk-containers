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

# Use awscli env
# It is the example as follows.

# BUCKET_NAME # from env (ex: hoge-system-stg-bucket)
# BUCKET_DIR # from env (ex: fetcher/moneyforward)
# AWS_DEFAULT_REGION # from env (ex: ap-northeast-1)
# AWS_ACCESS_KEY_ID # from env
# AWS_SECRET_ACCESS_KEY # from env

# args from env
# --endpoint-url=${BUCKET_URL}
# (ex: "https://s3.ap-northeast-1.wasabisys.com")

YYYYMM=`date +%Y%m`
YYYYMMDD=`date +%Y%m%d`

AWS_BIN="/usr/local/bin/aws/dist/aws"

FILE_DIR="/tmp/backup/"
SRC_DIR="/tmp/backup/"
REMOTE_DIR=${BUCKET_DIR}

if [ -z "${FILE_NAME}" ]; then
    echo "not set filename"
    FILE_NAME="${YYYYMMDD}"
    FILE_DIR="${FILE_DIR}/${YYYYMM}"
fi

echo "make YYYYMM directory"
mkdir -p ${FILE_DIR}

function dump () {
echo "mysqldump and output sql file"
mysqldump --single-transaction -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} > "${FILE_DIR}/${FILE_NAME}.sql"
cd ${FILE_DIR}

echo "compress sql file"
tar -zcvf ${FILE_NAME}.sql.tar.gz ${FILE_NAME}.sql

echo "remove raw dump file"
rm "${FILE_DIR}/${FILE_NAME}.sql"
}

function s3_upload () {
    echo "s3 upload start"
    if [ -n "$BUCKET_URL" ]; then
        ${AWS_BIN} s3 cp ${SRC_DIR} "s3://${BUCKET_NAME}/${REMOTE_DIR}" --recursive --endpoint-url="${BUCKET_URL}"
    else
        ${AWS_BIN} s3 cp ${SRC_DIR} "s3://${BUCKET_NAME}/${REMOTE_DIR}" --recursive
    fi
    echo "s3 upload complete"
}

dump

if [ -n "$BUCKET_NAME" ]; then
    s3_upload
fi
