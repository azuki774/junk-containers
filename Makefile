SHELL=/bin/bash

.PHONY: build

build:
	docker build -t dropbox_upload_batch:latest -f build/Dockerfile-dropbox-upload-batch .
