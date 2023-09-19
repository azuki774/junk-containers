#!/bin/bash
# SRC_DIR: remote, DST_DIR: local
# ディレクトリ中の YYYYMM / YYYYYMMDD は実際の日付に代入される
set -e

YYYYMM=`date '+%Y%m%d'`
YYYYMMDD=`date '+%Y%m%d'`
SRC_DIR=`echo ${SRC_DIR} | sed "s/YYYYMMDD/${YYYYMMDD}/g"`
SRC_DIR=`echo ${SRC_DIR} | sed "s/YYYYMM/${YYYYMM}/g"`
DST_DIR=`echo ${DST_DIR} | sed "s/YYYYMMDD/${YYYYMMDD}/g"`
DST_DIR=`echo ${DST_DIR} | sed "s/YYYYMM/${YYYYMM}/g"`
RSYNC_BIN=/usr/bin/rsync


mkdir -p ${DST_DIR}
${RSYNC_BIN} -e 'ssh -i ${SSH_KEY} \
-o StrictHostKeyChecking=no' \
-avz ${USER}@${TARGET_HOST}:${SRC_DIR}/* \ 
${DST_DIR}


for FILE in ${DST_DIR};
do
if [ ! -s $FILE ]; then
  echo "0 bytes file exists"
  exit 1
fi
done
