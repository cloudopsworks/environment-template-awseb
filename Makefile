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
	@if [ ! -f $(TARGET)-module.tf ] ; then \
		echo "Module $(TARGET)-module.tf not found... copying from template" ; \
		cp template-module.tf_template $(TARGET)-module.tf ; \
		mkdir -p values/${TARGET}/ ; \
		touch values/$(TARGET)/.placeholder ; \
	else echo "Module $(TARGET)-module.tf found... all OK" ; \
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
ifeq ($(OS),Darwin)
	sed -i "" -e "s/MODULE_NAME/$(TARGET)/g" $(TARGET)-module.tf
	sed -i "" -e "s/source_name[ \t]*=.*/source_name = \"$(CHART)\"/" $(TARGET)-module.tf
	sed -i "" -e "s/source_version[ \t]*=.*/source_version = \"$(RELEASE_VERSION)\"/" $(TARGET)-module.tf
	sed -i "" -e "s/release_name[ \t]*=.*/release_name = \"$(TARGET)\"/" $(TARGET)-module.tf
	sed -i "" -e "s/load_balancer_log_prefix[ \t]*=.*/load_balancer_log_prefix = \"$(TARGET)\"/" $(TARGET)-module.tf
	sed -i "" -e "s/load_balancer_alias[ \t]*=.*/load_balancer_alias = \"$(TARGET)\-ingress\"/" $(TARGET)-module.tf
	@if [ "$(PLATFORM)" != "" ] ; then \
		sed -i "" -e "s/SOLUTION_STACK/$(PLATFORM)/g" $(TARGET)-module.tf ; \
	fi
else ifeq ($(OS),Linux)
	sed -i -e "s/MODULE_NAME/$(TARGET)/g" $(TARGET)-module.tf
	sed -i -e "s/source_name[ \t]*=.*/source_name = \"$(CHART)\"/" $(TARGET)-module.tf
	sed -i -e "s/source_version[ \t]*=.*/source_version = \"$(RELEASE_VERSION)\"/" $(TARGET)-module.tf
	sed -i -e "s/release_name[ \t]*=.*/release_name = \"$(TARGET)\"/" $(TARGET)-module.tf
	sed -i -e "s/load_balancer_log_prefix[ \t]*=.*/load_balancer_log_prefix = \"$(TARGET)\"/" $(TARGET)-module.tf
	sed -i -e "s/#load_balancer_alias[ \t]*=.*/#load_balancer_alias = \"$(TARGET)\-ingress\"/" $(TARGET)-module.tf
	@if [ "$(PLATFORM)" != "" ] ; then \
		sed -i -e "s/SOLUTION_STACK/$(PLATFORM)/g" $(TARGET)-module.tf ; \
	fi
else
	echo "platfrom $(OS) not supported to release from"
	exit -1
endif

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

update:
	find values/ -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum > .values_hash
