VERSION := v1.0.0
SHELL   := $(shell which bash)
SELF    := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

HOSTS  ?= c1 c2 c3
DOMAIN ?= poc.svc

COUNTRY ?= PL

BITS ?= 4096
DAYS ?= 4096

define STDIN1
$(COUNTRY)
.
.
.
.
.
.
endef

define CSR_CNF
[req]
default_bits = $(BITS)
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = $(COUNTRY)
CN = $(if $(CUSTOM_CN),$(CUSTOM_CN),$(1))
endef

define STDIN2
$(COUNTRY)
.
.
.
.
$(if $(CUSTOM_CN),$(CUSTOM_CN),$(1))
.
.
.
endef

define V3_EXT
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = $(if $(CUSTOM_CN),$(CUSTOM_CN),$(1))
endef

export

.PHONY: all clean

all: keys cacert certs chains wildcard

clean:
	-rm -f $(SELF)/*.pem $(SELF)/*.cnf $(SELF)/*.ext $(SELF)/*.srl

.PHONY: keys

keys: $(SELF)/$(DOMAIN).key.pem $(HOSTS:%=$(SELF)/%.$(DOMAIN).key.pem)

$(SELF)/%.key.pem:
	openssl genrsa -out $@ $(BITS)

.PHONY: cacert

cacert: $(SELF)/$(DOMAIN).cacert.pem

$(SELF)/$(DOMAIN).cacert.pem: STDIN = $(call STDIN1)
$(SELF)/$(DOMAIN).cacert.pem: $(SELF)/$(DOMAIN).key.pem
	openssl req \
	-x509 -new \
	-nodes -key $< \
	-sha256 -days $(DAYS) \
	-out $@ <<< "$$STDIN"

.PHONY: certs

certs: $(HOSTS:%=$(SELF)/%.$(DOMAIN).cert.pem)

$(SELF)/%.csr.cnf: STDIN = $(call CSR_CNF,$*)
$(SELF)/%.csr.cnf:
	tee $@ <<< "$$STDIN"

$(SELF)/%.csr.pem: STDIN = $(call STDIN2,$*)
$(SELF)/%.csr.pem: $(SELF)/%.key.pem $(SELF)/%.csr.cnf
	openssl req \
	-new \
	-key $(word 1,$^) \
	-config $(word 2,$^) \
	-out $@ <<< "$$STDIN"

$(SELF)/%.v3.ext: STDIN = $(call V3_EXT,$*)
$(SELF)/%.v3.ext:
	tee $@ <<< "$$STDIN"

$(SELF)/%.cert.pem: $(SELF)/%.csr.pem $(SELF)/$(DOMAIN).key.pem $(SELF)/$(DOMAIN).cacert.pem $(SELF)/%.v3.ext
	openssl x509 \
	-req -in $(word 1,$^) \
	-CAkey $(word 2,$^) -CA $(word 3,$^) -CAcreateserial \
	-days $(DAYS) -sha256 -extfile $(word 4,$^) \
	-out $@

.PHONY: chains

chains: $(HOSTS:%=$(SELF)/%.$(DOMAIN).chain.pem) $(HOSTS:%=$(SELF)/%.$(DOMAIN).everything.pem)

$(SELF)/%.chain.pem: $(SELF)/%.cert.pem $(SELF)/$(DOMAIN).cacert.pem
	cat $^ > $@

$(SELF)/%.everything.pem: $(SELF)/%.cert.pem $(SELF)/$(DOMAIN).cacert.pem $(SELF)/%.key.pem
	cat $^ > $@

.PHONY: wildcard

wildcard: CUSTOM_CN = *.$(DOMAIN)
wildcard: $(SELF)/wildcard.$(DOMAIN).key.pem $(SELF)/wildcard.$(DOMAIN).cert.pem $(SELF)/wildcard.$(DOMAIN).chain.pem $(SELF)/wildcard.$(DOMAIN).everything.pem
