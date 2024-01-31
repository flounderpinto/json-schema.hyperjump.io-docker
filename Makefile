ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

CONTAINER_CODE_DIR=/opt/code

DOCKER_REGISTRY=index.docker.io/flounderpinto

INIT_CMD=git submodule update --init --recursive

DOCKER_REPO=json-schema-hyperjump-io
DOCKER_BUILD_BRANCH_CMD=dockerBuildStandardBranch -r ${DOCKER_REPO} ${ARGS}
DOCKER_BUILD_MAIN_CMD=dockerBuildStandardMain -r ${DOCKER_REPO} ${ARGS}
DOCKER_BUILD_TAG_CMD=dockerBuildStandardTag ${TAG} -r ${DOCKER_REPO} ${ARGS}
DOCKER_BUILDER_IMAGE=${DOCKER_REGISTRY}/builder-docker-flounderpinto:v0.2.0
DOCKER_BUILDER_PULL_CMD=docker pull ${DOCKER_BUILDER_IMAGE}
DOCKER_BUILDER_RUN_CMD=${DOCKER_BUILDER_PULL_CMD} && \
    docker run \
        --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ${HOME}/.docker:/tmp/.docker:ro \
        -v ${ROOT_DIR}:${CONTAINER_CODE_DIR} \
        ${DOCKER_BUILDER_IMAGE}

.PHONY: init docker docker_main docker_tag
.DEFAULT_GOAL := all

init:
	${INIT_CMD}

docker:
	${DOCKER_BUILDER_RUN_CMD} ${DOCKER_BUILD_BRANCH_CMD}

docker_main:
	${DOCKER_BUILDER_RUN_CMD} ${DOCKER_BUILD_MAIN_CMD}

docker_tag:
	test ${TAG}
	${DOCKER_BUILDER_RUN_CMD} ${DOCKER_BUILD_TAG_CMD}

#Everything right of the pipe is order-only prerequisites.
all: | init docker