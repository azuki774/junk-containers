SHELL=/bin/bash

.PHONY: build run

build:
	docker build -t dropbox-upload-batch:latest -f build/Dockerfile-dropbox-upload-batch .

run:
	docker compose -f deployment/dropbox-upload.yaml up
