BASE_IMAGE := outintech/nbjc-app
IMAGE_URL := ${BASE_IMAGE}:latest
BASE_DIR ?= ${shell git rev-parse --show-toplevel 2>/dev/null}
USER_ID := 1000
GROUP_ID := 1000

docker-clean:
	${BASE_DIR}/scripts/docker-clean.sh

image-create:
	docker build -t ${IMAGE_URL} --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID} .

image-push:
	docker push ${IMAGE_URL}

update-image: image-create image-push

migrate:
	docker container exec -it nbjc-app_api_1 rails db:migrate

docker-run-no-update: docker-clean
	docker-compose up -d

docker-run: docker-clean update-image
	docker-compose up -d
