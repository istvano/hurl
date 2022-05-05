#------------------------ INIT
ifeq (,$(wildcard Makefile.mk))
$(shell curl https://raw.githubusercontent.com/istvano/scripts/main/Makefile.mk --output Makefile.mk --silent)
$(error Makefile.mk does not exists - downloading it - Please run make again!)
endif

ifeq (,$(wildcard Makefile.help))
$(shell curl https://raw.githubusercontent.com/istvano/scripts/main/Makefile.help --output Makefile.help --silent)
$(error Makefile.help does not exists - downloading it - Please run make again!)
endif

ifeq (,$(wildcard .make-release-support))
$(shell curl https://raw.githubusercontent.com/istvano/scripts/main/.make-release-support --output .make-release-support --silent)
$(error .make-release-support does not exists - downloading it - Please run make again!)
endif
#-----------------------------

-include Makefile.help
-include Makefile.mk

# you can pass in build arguments to docker with
# DOCKER_BUILD_ARGS=--build-arg HURL_VERSION=1.6.1

MFILECWD = $(shell pwd)
NAME=$(shell basename $(CURDIR))

RELEASE_SUPPORT := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/.make-release-support
IMAGE=$(REGISTRY_HOST)/$(USERNAME)/$(NAME)

$(eval $(call defw,REGISTRY_HOST,docker.io))
$(eval $(call defw,USERNAME,$(USER)))
$(eval $(call defw,NAME,$(NAME)))
$(eval $(call defw,VERSION,$(shell . $(RELEASE_SUPPORT) ; getVersion)))
$(eval $(call defw,TAG,$(shell . $(RELEASE_SUPPORT); getTag)))

build: ##@docker builds a new version of image and tags it
showver: ##@docker shows the current release tag
snapshot: ##@docker builds from the current (dirty) and pushes the image to the registry 

test: ##@dev test docker images
	docker run -it --rm \
		--mount type=bind,source=$(MFILECWD),target=/hurl \
		$(IMAGE):latest \
		hurl /hurl/test.hurl

patch-release: ##@release incs the patch release level, build and push to registry
minor-release: ##@release incs the minor release level, build and push to registry
major-release: ##@release incs the major release level, build and push to registry
release: ##@release builds the current release and push the image to the registry

check-status: ##@git checks whether there are outstanding changes
check-release: ##@git checks whether the current directory matches the tagged release in git.