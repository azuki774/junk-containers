#!/bin/bash
set -e

TOKEN_ENDPOINT='https://api.dropbox.com/oauth2/token'
UPLOAD_ENDPOINT='https://content.dropboxapi.com/2/files/upload'

# DROPBOX_BASEDIR="/dropbox/"  # Dropbox copy base directory
# TARGET_DIR="./test"
# REFRESH_TOKEN=""  # OAuth2 Refresh token
# APP_KEY=""  # Dropbox app ley
# APP_SECRET  # Dropbox app secret

cd ${TARGET_DIR}

## Extract target file list
find . -type f > /tmp/FILELIST

## Fetch Access Token from Refresh Token
echo "Fetch new Access Token"

response=$(curl ${TOKEN_ENDPOINT} -w '\n%{http_code}' -s \
    -d refresh_token=${REFRESH_TOKEN} \
    -d grant_type=refresh_token \
    -u ${APP_KEY}:${APP_SECRET})

body=`echo "$response" | sed '$d'`
httpstatus=`echo "$response" | tail -n 1`

if [ "${httpstatus}" != '200' ]; then
    echo "Error: unexpect status code: ${httpstatus}" 1>&2
    exit 1
fi

ACCESS_TOKEN=$(echo ${body} | jq .access_token | sed 's/"//g') # " は消去する

while read FILE
do
    LOCAL_FILE="${FILE:2}" # Local File Name   ex: ./test1.txt -> test1.txt
    REMOTE_FILE="${DROPBOX_BASEDIR}${FILE:2}"   # Dropbox directory path
    echo "Local: ${LOCAL_FILE} -> Remote: ${REMOTE_FILE}" 

    response=$(curl -X POST ${UPLOAD_ENDPOINT} -w '\n%{http_code}' -s \
    --header "Authorization: Bearer ${ACCESS_TOKEN}" \
    --header "Dropbox-API-Arg: {\"autorename\":false,\"mode\":\"add\",\"mute\":false,\"path\":\"${REMOTE_FILE}\",\"strict_conflict\":false}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary ${LOCAL_FILE})

    body=`echo "$response" | sed '$d'`
    httpstatus=`echo "$response" | tail -n 1`

    ## 200 ok か確認、200 ならローカルファイル削除
    if [ "${httpstatus}" != '200' ]; then
        echo "Error: unexpect status code: ${httpstatus}" 1>&2
        exit 1
    fi

    rm -f ${LOCAL_FILE}

    # 空ディレクトリは消す
    find . -mindepth 1 -type d -empty | xargs --no-run-if-empty rm -r

done < /tmp/FILELIST

rm -f /tmp/FILELIST
