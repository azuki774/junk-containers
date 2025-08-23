SHELL=/bin/bash

.PHONY: build run

build:
	docker build -t mysql-dump:latest -f build/mysql-dump/Dockerfile .
	docker build -t postgres-dump:latest -f build/postgres-dump/Dockerfile .
run:
	docker compose -f deployment/mysql-dump.yaml up
