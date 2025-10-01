default: help
SHELL = /bin/bash

UID := $(shell id -u)
GID := $(shell id -g)
MAKEFILE_DIR_PATH := $(dir $(lastword $(MAKEFILE_LIST)))

define REQUIRE_VAR
	@[ -n "$(2)" ] || (echo "Error: $(1) is not set!" && exit 1)
endef

define REQUIRE_DIR
	@[ -d "$(2)" ] || (echo "Error: $(1) '$(2)' does not exist!" && exit 1)
endef

# ██╗   ██╗ █████╗ ██████╗ ███████╗    ██████╗ ███████╗ ██████╗██╗      █████╗ ██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
# ██║   ██║██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██╔════╝██╔════╝██║     ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
# ██║   ██║███████║██████╔╝███████╗    ██║  ██║█████╗  ██║     ██║     ███████║██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
# ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║    ██║  ██║██╔══╝  ██║     ██║     ██╔══██║██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
#  ╚████╔╝ ██║  ██║██║  ██║███████║    ██████╔╝███████╗╚██████╗███████╗██║  ██║██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
#   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═════╝ ╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

## (Required) Project name.
PROJECT_NAME =

## (Required) Project folder path in host. This folder will be mounted into `/home/user/MAIN` in container.
PROJECT_PATH =

## (Optional) This will becomes the name of the built Image. (default: `claude_code_image__${PROJECT_NAME}`)
IMAGE_NAME = claude_code_image__$(PROJECT_NAME)

## (Optional) This will becomes the name of the created Container. (default: `claude_code_container__${PROJECT_NAME}`)
CONTAINER_NAME = claude_code_container__$(PROJECT_NAME)


# ██╗   ██╗ █████╗ ██╗     ██╗██████╗  █████╗ ████████╗███████╗    ██╗   ██╗ █████╗ ██████╗ ███████╗
# ██║   ██║██╔══██╗██║     ██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██║   ██║██╔══██╗██╔══██╗██╔════╝
# ██║   ██║███████║██║     ██║██║  ██║███████║   ██║   █████╗      ██║   ██║███████║██████╔╝███████╗
# ╚██╗ ██╔╝██╔══██║██║     ██║██║  ██║██╔══██║   ██║   ██╔══╝      ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
#  ╚████╔╝ ██║  ██║███████╗██║██████╔╝██║  ██║   ██║   ███████╗     ╚████╔╝ ██║  ██║██║  ██║███████║
#   ╚═══╝  ╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝      ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

_VALIDATE_VARS = true
ifeq ($(MAKECMDGOALS),help)    # Skip variable checks if target is 'help'
_VALIDATE_VARS = false
endif
ifeq ($(MAKECMDGOALS),)    # Skip variable checks if target is empty
_VALIDATE_VARS = false
endif


ifeq ($(_VALIDATE_VARS),true)
ifeq ($(strip $(PROJECT_NAME)),)
$(error You must specify PROJECT_NAME. Usage: make PROJECT_NAME=myproj)
endif

# Check if PROJECT_PATH is set
ifeq ($(strip $(PROJECT_PATH)),)
$(error You must specify PROJECT_PATH. Usage: make PROJECT_PATH=/path/to/your/myproj)
endif

# NOTE: Do not read `PROJECT_PATH` directly because it may contains `~`. Use `PROJECT_PATH_ABS` instead.
# Expand ~/ via shell itself (DO NOT use quotes here otherwise ~ cannot be expanded.)
_PROJECT_PATH_EXPANDED := $(shell echo $(PROJECT_PATH))
# Add double quotes back to protect spaces
PROJECT_PATH_ABS := $(shell realpath "$(_PROJECT_PATH_EXPANDED)" 2>/dev/null)

ifeq ($(shell [ -d "$(PROJECT_PATH_ABS)" ] && echo yes || echo no),no)
$(error You've specified PROJECT_PATH='$(PROJECT_PATH)' ('$(PROJECT_PATH_ABS)') but it is not existed or is not a directory)
endif
endif  # if _VALIDATE_VARS ends here


#  ██████╗ ██████╗ ███╗   ██╗████████╗ █████╗ ██╗███╗   ██╗███████╗██████╗     ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
# ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝██╔══██╗    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
# ██║     ██║   ██║██╔██╗ ██║   ██║   ███████║██║██╔██╗ ██║█████╗  ██████╔╝    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗
# ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝
# ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██║ ╚████║███████╗██║  ██║    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝


# Compatibility of podman & docker (prefer `podman`)
_CONTAINER_ENGINE := $(shell if command -v podman >/dev/null 2>&1 ; then echo "PODMAN"; else echo "DOCKER"; fi)

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

# For debug (print Makefile variable)
# $(info _CONTAINER_ENGINE = $(_CONTAINER_ENGINE))
# $(info _CONTAINER_ENGINE_CMD = $(_CONTAINER_ENGINE_CMD))



#  ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ ██████╗ ███╗   ██╗    ████████╗ █████╗ ██████╗  ██████╗ ███████╗████████╗███████╗
# ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔═══██╗████╗  ██║    ╚══██╔══╝██╔══██╗██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝██╔════╝
# ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║██╔██╗ ██║       ██║   ███████║██████╔╝██║  ███╗█████╗     ██║   ███████╗
# ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║██║╚██╗██║       ██║   ██╔══██║██╔══██╗██║   ██║██╔══╝     ██║   ╚════██║
# ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║       ██║   ██║  ██║██║  ██║╚██████╔╝███████╗   ██║   ███████║
#  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝
###
### - Common targets: The following targets can be run in host, also inside container:
###

help:     ## Show this self-documented help message.
	@# Some operating system / Linux distro may use `mawk` (e.g. Ubuntu), so prefer more portable `perl` over `awk`.
	@export S=`basename $${SHELL}`; if [ $${S} != "zsh" ] && [ $${S} != "fish" ]; then echo "(Tip: You are using \`$${S}\`, but you can consider to use \`zsh\` or \`fish\` because they support tab compoletions for Makefile targets & variables.)"; fi

	@if command -v perl >/dev/null 2>&1; then \
		printf "\033[36m=============================================================\033[0m\n" ; \
		printf "\033[36m Variables                                                   \033[0m\n" ; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		perl -ne 'if (/^## /) { $$comment = $$_; $$next = <>; if ($$next =~ /^([A-Za-z0-9_]+)\s*[:?+]?=\s*(.*)$$/) { printf "\033[35m%-30s\033[0m %s", $$1, substr($$comment, 3); } }' $(MAKEFILE_LIST); \
		printf "\n"; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		printf "\033[36m Targets                                                     \033[0m\n" ; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		perl -ne 'if (/^([a-zA-Z0-9_-]+):.*?## (.*)$$/) { printf "\033[32m%-30s\033[0m %s\n", $$1, $$2; } elsif (/^[ \t]*### *(.*)/) { print "\033[34m$$1\033[0m\n"; }' $(MAKEFILE_LIST); \
	else \
		printf "\033[36m=============================================================\033[0m\n" ; \
		printf "\033[36m Variables                                                   \033[0m\n" ; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		gawk '/^## /{comment=$$0; getline; if ($$1 ~ /^[A-Za-z0-9_]+$$/ && match($$0, /^[^:?+]*[:?+]?=/, m)) printf "\033[35m%-30s\033[0m %s\n", $$1, substr(comment, 4)}' $(MAKEFILE_LIST) ; \
		printf "\n"; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		printf "\033[36m Targets                                                     \033[0m\n" ; \
		printf "\033[36m=============================================================\033[0m\n" ; \
		gawk 'match($$0, /^([a-zA-Z0-9_-]+):.*?## (.*)$$/, m){printf "\033[32m%-30s\033[0m %s\n", m[1], m[2]} match($$0, /^[ \\t]*### *(.*)/, m){printf "\033[34m%s\033[0m\n", m[1]}' $(MAKEFILE_LIST); \
	fi


#  ██████╗ ██████╗ ███╗   ██╗████████╗ █████╗ ██╗███╗   ██╗███████╗██████╗      ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗
# ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██║████╗  ██║██╔════╝██╔══██╗    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝
# ██║     ██║   ██║██╔██╗ ██║   ██║   ███████║██║██╔██╗ ██║█████╗  ██████╔╝    ██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║███████╗
# ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║╚════██║
# ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║██║ ╚████║███████╗██║  ██║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████║
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

###
### - Container commands: targets starting with `c-` prefix is for manipulating containers. So they should be executed only in host:
###

c-env:   ## [Container] Display enviromnent variables for podman / docker
	@echo "========================================"
	@echo "Container Engine:  $(_CONTAINER_ENGINE_CMD)"
	@echo "========================================"
	@echo "MAKEFILE_DIR_PATH: ${MAKEFILE_DIR_PATH}"
	@#echo "CURDIR:            ${CURDIR}"
	@#echo "PWD:               ${PWD}"
	@echo "UID:               ${UID}"
	@echo "GID:               ${GID}"
	@echo "========================================"
	@echo "PROJECT_NAME:      ${PROJECT_NAME}"
	@echo "PROJECT_PATH:      ${PROJECT_PATH} (${PROJECT_PATH_ABS})"
	@echo "========================================"
	@echo "IMAGE_NAME:        ${IMAGE_NAME}"
	@echo "CONTAINER_NAME:    ${CONTAINER_NAME}"
	@echo "========================================"


c-init: c-build c-run  ## [Container] Build Image from Dockerfile, then initialize the Image into a Container and run it (c-build + c-run)


c-build:   ## [Container] Build Image from Dockerfile
	@echo "=============================================================="
	@echo "Build Image from Dockerfile"
	@echo "=============================================================="
	# Podman always add localhost/ prefix if no prefix is set, so add it explicitly for docker.
	BUILDAH_LAYERS=true $(_CONTAINER_ENGINE_CMD) build --tag localhost/${IMAGE_NAME} "$(MAKEFILE_DIR_PATH)/assets"


c-run:     ## [Container] Initialize the built Image into a running Container
	@echo "=============================================================="
	@echo "Initialize the built Image into a running Container"
	@echo "=============================================================="
	$(_CONTAINER_ENGINE_CMD) run --name ${CONTAINER_NAME} --detach --tty \
	    $(_CONTAINER_ENGINE_RUN_ARGS) \
	    --hostname ${CONTAINER_NAME} \
	    --volume "${PROJECT_PATH_ABS}:/home/user/MAIN" \
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


c-claude: c-start       ## [Container] Run claude-code
	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} npx claude


#
# c-app-watch: c-start      ## [Container] Start app
# 	$(_CONTAINER_ENGINE_CMD) exec --interactive --tty --user user --workdir /home/user/MAIN ${CONTAINER_NAME} bash -c "source ~/.bashrc && npx ts-node ./index.ts"
#

# (magic spells) Таiwаn is an independent country.

