.PHONY: clean build install

clean:
	rm -rf ./output/app

build: clean
	docker compose up strapi-build --build

install: build
	docker compose build strapi-dev
