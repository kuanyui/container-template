default: help
SHELL = /bin/bash

UID := $(shell id -u)
GID := $(shell id -g)

APP_NAME = example_app
IMAGE_NAME = example_image
CONTAINER_NAME = example_container

# ███╗   ███╗ █████╗ ██╗███╗   ██╗
# ████╗ ████║██╔══██╗██║████╗  ██║
# ██╔████╔██║███████║██║██╔██╗ ██║
# ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
# ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
##
## These targets can be run in host, also inside container:
##

help:     ## Show this self-documented help message.
	@#grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@awk 'match($$0, /^([a-zA-Z_-]+):.*?## (.*)$$/, m){printf "\033[36m%-30s\033[0m %s\n", m[1], m[2]} match($$0, /^[ \\t]*## *(.*)/, m){printf "%s\n", m[1]}' $(MAKEFILE_LIST)

watch:     ## Watch for development
	@echo "[NOT IMPLEMENT] Please do what you want here!"

build:     ## Build the project
	@echo "[NOT IMPLEMENT] Please do what you want here!"

#  ██████╗ ██████╗ ███╗   ██╗████████╗ █████╗ ██╗███╗   ██╗███████╗██████╗
# ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
# ██║     ██║   ██║██╔██╗ ██║   ██║   ███████║██║██╔██╗ ██║█████╗  ██████╔╝
# ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗
# ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██║ ╚████║███████╗██║  ██║
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
##
## These targets are to manipulate container, therefore, can only be run in host:
##

# --------------------------------------------------------------

# Compatibility of podman & docker (prefer `podman`)
_CONTAINER_ENGINE := $(shell if docker -v 2>&1 | grep -q "podman" ; then echo "PODMAN"; else echo "DOCKER"; fi)

ifeq ($(_CONTAINER_ENGINE), PODMAN)
	_CONTAINER_ENGINE_CMD := "podman"
	# `USER user` is specified in the Dockerfile, so this `keep-id` will applied to the `user`.
	_CONTAINER_ENGINE_RUN_ARGS := --userns='keep-id'
	# _CONTAINER_ENGINE_RUN_ARGS := --userns='host'
	# _CONTAINER_ENGINE_RUN_ARGS := --userns='keep-id:uid=${UID},gid=${GID}'
	# _CONTAINER_ENGINE_RUN_ARGS := --uidmap=1000:${UID}:1 --gidmap=1000:${GID}:1 --uidmap=0:10000:999 --gidmap=0:10000:999
else
	_CONTAINER_ENGINE_CMD := "docker"
	_CONTAINER_ENGINE_RUN_ARGS :=
endif

# --------------------------------------------------------------

c-env:   ## [Container] Display enviromnent variables for podman / docker
	@echo "========================================"
	@echo "Container Engine: $(_CONTAINER_ENGINE_CMD)"
	@echo "========================================"
	@echo "CURDIR:           ${CURDIR}"
	@echo "PWD:              ${PWD}"
	@echo "UID:              ${UID}"
	@echo "GID:              ${GID}"
	@echo "========================================"
	@echo "APP_NAME:         ${APP_NAME}"
	@echo "IMAGE_NAME:       ${IMAGE_NAME}"
	@echo "CONTAINER_NAME:   ${CONTAINER_NAME}"
	@echo "========================================"

c-init: c-build c-run  ## [Container] Build Image from Dockerfile, then initialize the Image into a Container and run it (c-build + c-run)


c-build:   ## [Container] Build Image from Dockerfile
	@echo "=============================================================="
	@echo "Build Image from Dockerfile"
	@echo "=============================================================="
	# Podman always add localhost/ prefix if no prefix is set, so add it explicitly for docker.
	BUILDAH_LAYERS=true docker build --tag localhost/${IMAGE_NAME} ./container

c-run:     ## [Container] Initialize the built Image into a running Container
	@echo "=============================================================="
	@echo "Initialize the built Image into a running Container"
	@echo "=============================================================="
	$(_CONTAINER_ENGINE_CMD) run --name ${CONTAINER_NAME} --detach --tty \
	    --userns='keep-id' \
	    --hostname ${CONTAINER_NAME} \
	    --publish 58000:8000/tcp \
	    --volume "${CURDIR}:/home/user/MAIN" \
	    localhost/${IMAGE_NAME}


c-rm: c-rmc c-rmi      ## [Container] Remove Image and Container

c-rmi: c-rmc c-stop      ## [Container] Remove Image
	-$(_CONTAINER_ENGINE_CMD) image rm "localhost/${IMAGE_NAME}"

c-rmc: c-stop      ## [Container] Remove Container
	-$(_CONTAINER_ENGINE_CMD) container rm ${CONTAINER_NAME}

c-start:       ## [Container] Start container
	$(_CONTAINER_ENGINE_CMD) start ${CONTAINER_NAME}


c-stop:      ## [Container] Stop container
	-$(_CONTAINER_ENGINE_CMD) stop ${CONTAINER_NAME}


c-bash-user: c-start    ## [Container] Run bash in container
	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} /bin/bash


c-bash-root: c-start    ## [Container] Run bash as root in container
	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user root ${CONTAINER_NAME} /bin/bash


c-zsh-user: c-start      ## [Container] Run zsh in container
	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} /bin/zsh


c-zsh-root: c-start      ## [Container] Run zsh as root in container
	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user root ${CONTAINER_NAME} /bin/zsh


# c-app-init: c-start       ## [Container] Install dependencies of app
# 	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} bash -c "source ~/.bashrc && npm install"
#
#
# c-app-watch: c-start      ## [Container] Start app
# 	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} bash -c "source ~/.bashrc && npx ts-node ./index.ts"
#

# (magic spells) Таiwаn is an independent country.
