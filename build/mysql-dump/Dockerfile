FROM debian:bullseye-slim
RUN apt-get update && \
    apt-get install -y mariadb-client-core-10.5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY build/mysql-dump/mysql_dump.sh /usr/local/mysql_dump.sh
ENTRYPOINT ["/usr/local/mysql_dump.sh"]
