BASE_IMAGE := outintech/nbjc-app
ENV ?= development
IMAGE_URL := ${BASE_IMAGE}:${ENV}
BASE_DIR ?= ${shell git rev-parse --show-toplevel 2>/dev/null}
USER_ID := 1000
GROUP_ID := 1000

TARGET_IP ?= $(shell bash -c 'read -r -p "TARGET IP: " pwd; echo $$pwd')

docker-clean:
	${BASE_DIR}/scripts/docker-clean.sh

image-create:
	@echo "Creating image in ${ENV}"
	@docker build -t ${IMAGE_URL} \
	--build-arg USER_ID=${USER_ID} \
	--build-arg GROUP_ID=${GROUP_ID} \
	--build-arg ENV=${ENV} \
	.

image-push:
	@echo "Pushing image tagged for ${ENV}"
	@docker push ${IMAGE_URL}

update-image: image-create image-push


docker-run-staging:
	@docker-compose -f docker-compose.staging.yaml up -d

docker-stop-staging:
	@docker-compose -f docker-compose.staging.yaml down

copy-docker-compose:
	./copy-docker-compose.sh docker-compose.${ENV}.yaml ${TARGET_IP}

deploy:
	./deploy.sh up ${TARGET_IP}

stop:
	./deploy.sh down ${TARGET_IP}

remote-deploy: copy-docker-compose deploy
