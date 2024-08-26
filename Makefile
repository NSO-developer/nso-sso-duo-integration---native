PKG_DIR = $(NCS_DIR)/packages/auth/cisco-nso-saml2-auth


.PHONY: all
all: saml_pkg 
	$(MAKE) stop start cisco-nso-saml2-auth.xml


saml_pkg: packages/cisco-nso-saml2-auth \
		cisco-nso-saml2-auth-deps
	$(MAKE) -C packages/cisco-nso-saml2-auth/src all

packages/cisco-nso-saml2-auth:
	cd packages/ ; git clone git@github.com:NSO-developer/nso-sso-duo-integration-package.git
	cd packages/ ; mv nso-sso-duo-integration---package cisco-nso-saml2-auth

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
