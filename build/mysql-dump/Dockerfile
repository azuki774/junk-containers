FROM debian:bullseye-slim
RUN apt-get update && \
    apt-get install -y mariadb-client-10.5 unzip curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# AWS Setup
RUN curl -o /var/tmp/awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -d /usr/local/bin/ /var/tmp/awscli.zip

COPY build/mysql-dump/mysql_dump.sh /usr/local/mysql_dump.sh
ENTRYPOINT ["/usr/local/mysql_dump.sh"]
