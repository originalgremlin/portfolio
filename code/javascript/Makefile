include ../Makefile.base

NAME=javascript
VERSION=8.9.3-r1

run:
	docker run -it --name $(NAME) --rm \
		-p 3000:3000 \
		-v $(CURDIR)/root/usr/local/src/server.js:/usr/local/src/server.js \
		$(IMAGE):$(VERSION)
