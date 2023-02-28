SHELL=/bin/bash

.PHONY: build run

build:
	docker build -t dropbox-upload-batch:latest -f build/Dockerfile-dropbox-upload-batch .
	docker build -t mysql-dump:latest -f build/Dockerfile-mysql-dump .

run:
	docker compose -f deployment/dropbox-upload.yaml up
