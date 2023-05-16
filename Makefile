##
# (c) 2021 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
OS := $(shell uname)
PWD := $(shell pwd)
CURR := $(shell basename $(PWD))
VERFOUND := $(shell [ -f VERSION ] && echo 1 || echo 0)
RELEASE_VERSION :=
TARGET :=
CHART :=
PLATFORM :=

.PHONY: VERSION
.PHONY: version
.PHONY: module.tf
.PHONY: config
.PHONY: update

module.tf:
	@if [ ! -f $(TARGET)-module.yaml ] ; then \
		echo "Module $(TARGET)-module.yaml not found... copying from template" ; \
		cp template-module.yaml_template $(TARGET)-module.yaml ; \
		mkdir -p values/${TARGET}/ ; \
		touch values/$(TARGET)/.placeholder ; \
	else echo "Module $(TARGET)-module.yaml found... all OK" ; \
	fi
# ifeq "" "$(T)"
# 	$(info )
# ifeq ($(OS),Darwin)
# else ifeq ($(OS),Linux)
# else
# 	echo "platfrom $(OS) not supported to release from"
# 	exit -1
# endif
# else
# 	$(info )
# endif

version: VERSION module.tf
	yq eval -i '.module = "$(TARGET)"' $(TARGET)-module.yaml
	yq eval -i '.release.name = "$(TARGET)"' $(TARGET)-module.yaml
	yq eval -i '.release.source.name = "$(CHART)"' $(TARGET)-module.yaml
	yq eval -i '.release.source.version = "$(RELEASE_VERSION)"' $(TARGET)-module.yaml
	@if [ "$(PLATFORM)" != "" ] ; then \
		yq eval -i '.beanstalk.solution_stack = "$(PLATFORM)"' $(TARGET)-module.yaml ; \
	fi

VERSION:
ifeq ($(VERFOUND),1)
	$(info Version File OK)
override RELEASE_VERSION := $(shell cat VERSION | grep VERSION | cut -f 2 -d "=")
override TARGET := $(shell cat VERSION | grep TARGET | cut -f 2 -d "=")
override CHART := $(shell cat VERSION | grep CHART | cut -f 2 -d "=")
override PLATFORM := $(shell cat VERSION | grep PLATFORM | cut -f 2 -d "=")
else
	$(error Hey $@ File not found)
endif

clean:
	rm -f VERSION


init-template:
	@if [ ! -f terraform.tfvars ] ; then \
		echo "Initial Variables terraform.tfvars not found... copying from template" ; \
		cp terraform.tfvars_template terraform.tfvars ; \
	else echo "Initial Variables terraform.tfvars found... all OK" ; \
	fi

init: init-template
ifeq ($(OS),Darwin)
	sed -i "" -e "s/default_bucket_prefix[ \t]*=.*/default_bucket_prefix = \"$(CURR)\"/" terraform.tfvars
else ifeq ($(OS),Linux)
	sed -i -e "s/default_bucket_prefix[ \t]*=.*/default_bucket_prefix = \"$(CURR)\"/" terraform.tfvars
else
	echo "platfrom $(OS) not supported to release from"
	exit -1
endif
	@if [ ! -f backend.tf ] ; then \
		echo "Backend backend.tf not found... copying from template" ; \
		cp backend.tf_template backend.tf ; \
	else echo "Backend terraform.tfvars found... all OK" ; \
	fi
	@if [ ! -f OWNERS ] ; then \
		echo "Owners file OWNERS not found... copying from template" ; \
		cp OWNERS_template OWNERS ; \
	else echo "Owners file OWNERS found... all OK" ; \
	fi

config: clean
	@read -p "Enter Branch Name (no spaces):" the_branch ; \
	git checkout -b config-$${the_branch} ; \
	git push -u origin config-$${the_branch}

#update:
#	find values/ -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum > .values_hash
