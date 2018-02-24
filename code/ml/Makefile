include ../Makefile.base

NAME=ml
VERSION=1.0.0

run:
	docker run -it --rm --hostname $(NAME) --name $(NAME) \
		-p 8888:8888 \
		-v data:/usr/local/data \
		-v notebooks:/usr/local/notebooks \
		$(IMAGE):$(VERSION)
