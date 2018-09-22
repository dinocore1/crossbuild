.PHONY: build shell


IMAGE := devsmart/crossbuild:dev

all: build

build: Dockerfile $(shell find assets)
	docker build -t $(IMAGE)

shell:
	docker run -it --rm $(IMAGE) bash