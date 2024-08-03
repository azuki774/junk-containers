# junk-containers

## mysql-dump
- mysqldump して sql ファイルを圧縮したものを、`/tmp/backup/YYYYMM/YYYYMMDD.sql.tar.gz` に配置する
- 環境変数: `FILENAME` セット時は、`/tmp/backup/${FILE_NAME}.sql.tar.gz` に mysqldump を保存する。
