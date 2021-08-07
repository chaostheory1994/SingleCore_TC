# Overloadable parameters
# List of tags to apply to the docker images
DOCKER_TAGS ?= latest

# Docker Targets
MAPEXTRACTOR_IMAGE_NAME = mapextractor
MMAPS_GENERATOR_IMAGE_NAME = mmaps_generator
VMAP4EXTRACTOR_IMAGE_NAME = vmap4extractor
WORLDSERVER_IMAGE_NAME = worldserver
BNETSERVER_IMAGE_NAME = bnetserver

# Docker commands
DOCKER_B = docker build
DOCKER_T = docker tag
DOCKER_RMI = docker rmi
DOCKER_I = docker images
DOCKER_P = docker push

# Docker flags
MAP_EXTRACTOR_FILTER = --filter "label=name=$(MAPEXTRACTOR_IMAGE_NAME)"
MMAPS_GENERATOR_FILTER = --filter "label=name=$(MMAPS_GENERATOR_IMAGE_NAME)"
VMAP4_EXTRACTOR_FILTER = --filter "label=name=$(VMAP4EXTRACTOR_IMAGE_NAME)"
WORLDSERVER_FILTER = --filter "label=name=$(WORLDSERVER_IMAGE_NAME)"
BNETSERVER_FILTER = --filter "label=name=$(BNETSERVER_IMAGE_NAME)"
DANGLING_FILTER = --filter "dangling=true"
ID_FORMAT = --format "{{.ID}}"
TARGET_ENV_STEP = --target environment
TARGET_BUILD_STEP = --target buildStep
TARGET_MAP_EXTRACTOR = --target $(MAPEXTRACTOR_IMAGE_NAME)
TARGET_MMAPS_GENERATOR = --target $(MMAPS_GENERATOR_IMAGE_NAME)
TARGET_VMAP4_EXTRACTOR = --target $(VMAP4EXTRACTOR_IMAGE_NAME)
TARGET_WORLDSERVER = --target $(WORLDSERVER_IMAGE_NAME)
TARGET_BNETSERVER = --target $(BNETSERVER_IMAGE_NAME)
TAG_MAP_EXTRACTOR = -t $(MAPEXTRACTOR_IMAGE_NAME)
TAG_MMAPS_GENERATOR = -t $(MMAPS_GENERATOR_IMAGE_NAME)
TAG_VMAP4_EXTRACTOR = -t $(VMAP4EXTRACTOR_IMAGE_NAME)
TAG_WOLRDSERVER = -t $(WORLDSERVER_IMAGE_NAME)
TAG_BNETSERVER = -t $(BNETSERVER_IMAGE_NAME)

# This will tag a local docker iamge
# $(1): the name of the local docker image
# $(2): the name of the tag to apply to the image
define tag_docker_image
$(DOCKER_T) $(1) $(1):$(2)
endef

# Function to generate a new line for make
define NEWLINE


endef

.PHONY: all build_mapextractor build_mmaps_generator build_vmap4extractor build_code build_worldserver build_bnetserver

all: build_mapextractor build_mmaps_generator build_vmap4extractor build_worldserver build_bnetserver

build_env:
	$(DOCKER_B) $(TARGET_ENV_STEP) .

build_code: build_env
	$(DOCKER_B) $(TARGET_BUILD_STEP) .

build_mapextractor: build_code
	$(DOCKER_B) $(TARGET_MAP_EXTRACTOR) $(TAG_MAP_EXTRACTOR) .
	$(foreach tag,$(DOCKER_TAGS),$(call tag_docker_image,$(MAPEXTRACTOR_IMAGE_NAME),$(tag))$(NEWLINE))

build_mmaps_generator: build_code
	$(DOCKER_B) $(TARGET_MMAPS_GENERATOR) $(TAG_MMAPS_GENERATOR) .
	$(foreach tag,$(DOCKER_TAGS),$(call tag_docker_image,$(MMAPS_GENERATOR_IMAGE_NAME),$(tag))$(NEWLINE))

build_vmap4extractor: build_code
	$(DOCKER_B) $(TARGET_VMAP4_EXTRACTOR) $(TAG_VMAP4_EXTRACTOR) .
	$(foreach tag,$(DOCKER_TAGS),$(call tag_docker_image,$(VMAP4EXTRACTOR_IMAGE_NAME),$(tag))$(NEWLINE))

build_worldserver: build_code
	$(DOCKER_B) $(TARGET_WORLDSERVER) $(TARGET_WORLDSERVER) .
	$(foreach tag,$(DOCKER_TAGS),$(call tag_docker_image,$(WORLDSERVER_IMAGE_NAME),$(tag))$(NEWLINE))

build_bnetserver: build_code
	$(DOCKER_B) $(TARGET_BNETSERVER) $(TAG_BNETSERVER) .
	$(foreach tag,$(DOCKER_TAGS),$(call tag_docker_image,$(BNETSERVER_IMAGE_NAME),$(tag))$(NEWLINE))

clean:
	$(DOCKER_RMI) $$($(DOCKER_I) $(MAP_EXTRACTOR_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
	$(DOCKER_RMI) $$($(DOCKER_I) $(MMAPS_GENERATOR_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
	$(DOCKER_RMI) $$($(DOCKER_I) $(VMAP4_EXTRACTOR_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
	$(DOCKER_RMI) $$($(DOCKER_I) $(WORLDSERVER_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
	$(DOCKER_RMI) $$($(DOCKER_I) $(BNETSERVER_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
	$(DOCKER_RMI) $$($(DOCKER_I) $(DANGLING_FILTER) $(ID_FORMAT)) || echo "Nothing to delete"
