PKG_DIR = $(NCS_DIR)/packages/auth/cisco-nso-saml2-auth
NCS_VER = $(shell ncs --version)
#NCS_VER_SPLIT = $(shell python -c "ver=str('$(NCS_VER)').split('.'); print(ver[0]+'.'+ver[1])")
NCS_VER_SPLIT = "cli_auth"

.PHONY: all
all: saml_pkg build_duo
	$(MAKE) stop start cisco-nso-saml2-auth.xml


saml_pkg: packages/cisco-nso-saml2-auth \
		cisco-nso-saml2-auth-deps
	$(MAKE) -C packages/cisco-nso-saml2-auth/src all

packages/cisco-nso-saml2-auth:
	cd packages/ && git clone https://github.com/NSO-developer/nso-sso-duo-integration-package.git
	cd packages/nso-sso-duo-integration-package && git checkout $(NCS_VER_SPLIT)
	cd packages/nso-sso-duo-integration-package && $(MAKE) deps 
	cd packages/ ; mv nso-sso-duo-integration-package cisco-nso-saml2-auth


build_duo:
	$(MAKE) -C packages/cisco-nso-saml2-auth duo

pyvenv:
	pip $(PIP_OPTS) install pip --upgrade

cisco-nso-saml2-auth-deps: pyvenv
	pip install -r $(PKG_DIR)/requirements.txt
	touch $@

keys:
	./$@.gen

cisco-nso-saml2-auth.xml: keys
	bash start.sh $(DUO_URL) $(NSO_URL)


.PHONY: clean
clean:
	$(MAKE) -C packages/cisco-nso-saml2-auth/src clean || true
	rm -rf ./netsim running.DB logs/* state/* ncs-cdb/*
	rm -rf keys  __pycache__
	rm -f cisco-nso-saml2-auth-deps cisco-nso-saml2-auth.xml
	rm -rf packages/cisco-nso-saml2-auth
	rm -rf packages/nso-sso-duo-integration-package


clean-logs:
	rm -f logs/*

.PHONY: start
start:
	ncs

.PHONY: stop
stop:
	-ncs --stop

.PHONY: cli-c
cli-c:
	ncs_cli -C -uadmin

.PHONY: cli-j
cli-j:
	ncs_cli -J -uadmin
