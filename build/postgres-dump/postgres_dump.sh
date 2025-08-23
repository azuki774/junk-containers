#!/bin/bash
set -e

### if FILE_NAME is not set
# /tmp/backup/YYYYMM/YYYYMMDD.sql.tar.gz に postgres dump を保存する。

### FILE_NAME is set
# /tmp/backup/${FILE_NAME}.sql.tar.gz に postgres dump を保存する。

# env list
# POSTGRES_USER
# POSTGRES_DB
# POSTGRES_HOST
# POSTGRES_PASSWORD

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
    echo "Starting PostgreSQL dump..."
    # Wait for database to be ready
    until pg_isready -h ${POSTGRES_HOST} -U ${POSTGRES_USER}; do
        echo "Waiting for database to be ready..."
        sleep 2
    done

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    DUMP_FILE="${FILE_DIR}/${FILE_NAME}.sql"

    # Create dump with password from environment
    PGPASSWORD=${POSTGRES_PASSWORD} pg_dump -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -d ${POSTGRES_DB} > ${DUMP_FILE}

    if [ $$? -eq 0 ]; then
        echo "Dump created successfully: $DUMP_FILE"
        
        # Compress the dump file
        gzip $DUMP_FILE
        echo "Dump compressed: $DUMP_FILE.gz"
        
        # Set appropriate permissions
        chmod 644 $DUMP_FILE.gz
        echo "Backup completed successfully"
    else
        echo "Dump creation failed"
        exit 1
    fi
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
