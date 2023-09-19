SHELL=/bin/bash

.PHONY: build run

build:
	docker build -t dropbox-upload-batch:latest -f build/Dockerfile-dropbox-upload-batch .
	docker build -t mysql-dump:latest -f build/Dockerfile-mysql-dump .
	docker build -t downloader:latest -f build/Dockerfile-downloader .

run:
	docker compose -f deployment/dropbox-upload.yaml up

test:
	# mysql-dump
	- docker network rm ci_network
	- docker network create --driver bridge ci_network
	docker compose -f deployment/mariadb-ci.yaml up -d
	sleep 10s
	docker compose -f deployment/mysql-dump.yaml up
	docker compose -f deployment/mariadb-ci.yaml down
	docker network rm ci_network
