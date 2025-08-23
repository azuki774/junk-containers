FROM postgres:15

RUN apt-get update && \
    apt-get install -y unzip curl && \
    rm -rf /var/lib/apt/lists/*

# AWS Setup
RUN curl -o /var/tmp/awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -d /usr/local/bin/ /var/tmp/awscli.zip

COPY build/postgres-dump/postgres_dump.sh /usr/local/postgres_dump.sh
ENTRYPOINT ["/usr/local/postgres_dump.sh"]
