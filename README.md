quick-ca
========

## 1. About

A simple makefile that creates self-signed CA using openssl (for testing purposes).

## 2. Prereq

- bash
- coreutils
- make (GNU)
- openssl

## 3. Usage

### 3.1 Basic

```
$ make
openssl genrsa -out /home/asd/_git/quick-ca/poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c1.poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c2.poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c3.poc.lh.key.pem 4096
openssl req \
-x509 -new \
-nodes -key /home/asd/_git/quick-ca/poc.lh.key.pem \
-sha256 -days 4096 \
-out /home/asd/_git/quick-ca/poc.lh.cacert.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c1.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c1.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/c1.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/c1.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/c1.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c1.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c1.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/c1.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c1.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/c1.poc.lh.cert.pem
tee /home/asd/_git/quick-ca/c2.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c2.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/c2.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/c2.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/c2.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c2.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c2.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/c2.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c2.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/c2.poc.lh.cert.pem
tee /home/asd/_git/quick-ca/c3.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c3.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/c3.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/c3.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/c3.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c3.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c3.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/c3.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c3.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/c3.poc.lh.cert.pem
cat /home/asd/_git/quick-ca/c1.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/c1.poc.lh.chain.pem
cat /home/asd/_git/quick-ca/c2.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/c2.poc.lh.chain.pem
cat /home/asd/_git/quick-ca/c3.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/c3.poc.lh.chain.pem
openssl genrsa -out /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem 4096
tee /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = *.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem
cat /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/wildcard.poc.lh.chain.pem
rm /home/asd/_git/quick-ca/c1.poc.lh.csr.cnf /home/asd/_git/quick-ca/c2.poc.lh.csr.pem /home/asd/_git/quick-ca/c2.poc.lh.v3.ext /home/asd/_git/quick-ca/c1.poc.lh.v3.ext /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf /home/asd/_git/quick-ca/c1.poc.lh.csr.pem /home/asd/_git/quick-ca/c3.poc.lh.v3.ext /home/asd/_git/quick-ca/c3.poc.lh.csr.pem /home/asd/_git/quick-ca/c2.poc.lh.csr.cnf /home/asd/_git/quick-ca/c3.poc.lh.csr.cnf /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem
```

```
$ ls -1 *.pem
c1.poc.lh.cert.pem
c1.poc.lh.chain.pem
c1.poc.lh.key.pem
c2.poc.lh.cert.pem
c2.poc.lh.chain.pem
c2.poc.lh.key.pem
c3.poc.lh.cert.pem
c3.poc.lh.chain.pem
c3.poc.lh.key.pem
poc.lh.cacert.pem
poc.lh.key.pem
wildcard.poc.lh.cert.pem
wildcard.poc.lh.chain.pem
wildcard.poc.lh.key.pem
```

### 3.2 Custom domain

```
$ make DOMAIN=example.org
openssl genrsa -out /home/asd/_git/quick-ca/example.org.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c1.example.org.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c2.example.org.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c3.example.org.key.pem 4096
openssl req \
-x509 -new \
-nodes -key /home/asd/_git/quick-ca/example.org.key.pem \
-sha256 -days 4096 \
-out /home/asd/_git/quick-ca/example.org.cacert.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c1.example.org.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c1.example.org
openssl req \
-new \
-key /home/asd/_git/quick-ca/c1.example.org.key.pem \
-config /home/asd/_git/quick-ca/c1.example.org.csr.cnf \
-out /home/asd/_git/quick-ca/c1.example.org.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c1.example.org.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c1.example.org
openssl x509 \
-req -in /home/asd/_git/quick-ca/c1.example.org.csr.pem \
-CAkey /home/asd/_git/quick-ca/example.org.key.pem -CA /home/asd/_git/quick-ca/example.org.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c1.example.org.v3.ext \
-out /home/asd/_git/quick-ca/c1.example.org.cert.pem
tee /home/asd/_git/quick-ca/c2.example.org.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c2.example.org
openssl req \
-new \
-key /home/asd/_git/quick-ca/c2.example.org.key.pem \
-config /home/asd/_git/quick-ca/c2.example.org.csr.cnf \
-out /home/asd/_git/quick-ca/c2.example.org.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c2.example.org.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c2.example.org
openssl x509 \
-req -in /home/asd/_git/quick-ca/c2.example.org.csr.pem \
-CAkey /home/asd/_git/quick-ca/example.org.key.pem -CA /home/asd/_git/quick-ca/example.org.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c2.example.org.v3.ext \
-out /home/asd/_git/quick-ca/c2.example.org.cert.pem
tee /home/asd/_git/quick-ca/c3.example.org.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c3.example.org
openssl req \
-new \
-key /home/asd/_git/quick-ca/c3.example.org.key.pem \
-config /home/asd/_git/quick-ca/c3.example.org.csr.cnf \
-out /home/asd/_git/quick-ca/c3.example.org.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c3.example.org.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c3.example.org
openssl x509 \
-req -in /home/asd/_git/quick-ca/c3.example.org.csr.pem \
-CAkey /home/asd/_git/quick-ca/example.org.key.pem -CA /home/asd/_git/quick-ca/example.org.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c3.example.org.v3.ext \
-out /home/asd/_git/quick-ca/c3.example.org.cert.pem
cat /home/asd/_git/quick-ca/c1.example.org.cert.pem /home/asd/_git/quick-ca/example.org.cacert.pem > /home/asd/_git/quick-ca/c1.example.org.chain.pem
cat /home/asd/_git/quick-ca/c2.example.org.cert.pem /home/asd/_git/quick-ca/example.org.cacert.pem > /home/asd/_git/quick-ca/c2.example.org.chain.pem
cat /home/asd/_git/quick-ca/c3.example.org.cert.pem /home/asd/_git/quick-ca/example.org.cacert.pem > /home/asd/_git/quick-ca/c3.example.org.chain.pem
openssl genrsa -out /home/asd/_git/quick-ca/wildcard.example.org.key.pem 4096
tee /home/asd/_git/quick-ca/wildcard.example.org.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = *.example.org
openssl req \
-new \
-key /home/asd/_git/quick-ca/wildcard.example.org.key.pem \
-config /home/asd/_git/quick-ca/wildcard.example.org.csr.cnf \
-out /home/asd/_git/quick-ca/wildcard.example.org.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/wildcard.example.org.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.example.org
openssl x509 \
-req -in /home/asd/_git/quick-ca/wildcard.example.org.csr.pem \
-CAkey /home/asd/_git/quick-ca/example.org.key.pem -CA /home/asd/_git/quick-ca/example.org.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/wildcard.example.org.v3.ext \
-out /home/asd/_git/quick-ca/wildcard.example.org.cert.pem
cat /home/asd/_git/quick-ca/wildcard.example.org.cert.pem /home/asd/_git/quick-ca/example.org.cacert.pem > /home/asd/_git/quick-ca/wildcard.example.org.chain.pem
rm /home/asd/_git/quick-ca/wildcard.example.org.v3.ext /home/asd/_git/quick-ca/c2.example.org.csr.pem /home/asd/_git/quick-ca/c2.example.org.csr.cnf /home/asd/_git/quick-ca/wildcard.example.org.csr.cnf /home/asd/_git/quick-ca/c1.example.org.csr.pem /home/asd/_git/quick-ca/c1.example.org.csr.cnf /home/asd/_git/quick-ca/c3.example.org.v3.ext /home/asd/_git/quick-ca/c1.example.org.v3.ext /home/asd/_git/quick-ca/c2.example.org.v3.ext /home/asd/_git/quick-ca/c3.example.org.csr.cnf /home/asd/_git/quick-ca/wildcard.example.org.csr.pem /home/asd/_git/quick-ca/c3.example.org.csr.pem
```

```
$ ls -1 *.pem
c1.example.org.cert.pem
c1.example.org.chain.pem
c1.example.org.key.pem
c2.example.org.cert.pem
c2.example.org.chain.pem
c2.example.org.key.pem
c3.example.org.cert.pem
c3.example.org.chain.pem
c3.example.org.key.pem
example.org.cacert.pem
example.org.key.pem
wildcard.example.org.cert.pem
wildcard.example.org.chain.pem
wildcard.example.org.key.pem
```

### 3.3 Custom hosts

```
$ make HOSTS="a b c"
openssl genrsa -out /home/asd/_git/quick-ca/poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/a.poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/b.poc.lh.key.pem 4096
openssl genrsa -out /home/asd/_git/quick-ca/c.poc.lh.key.pem 4096
openssl req \
-x509 -new \
-nodes -key /home/asd/_git/quick-ca/poc.lh.key.pem \
-sha256 -days 4096 \
-out /home/asd/_git/quick-ca/poc.lh.cacert.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/a.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = a.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/a.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/a.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/a.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/a.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = a.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/a.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/a.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/a.poc.lh.cert.pem
tee /home/asd/_git/quick-ca/b.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = b.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/b.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/b.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/b.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/b.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = b.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/b.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/b.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/b.poc.lh.cert.pem
tee /home/asd/_git/quick-ca/c.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = c.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/c.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/c.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/c.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/c.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = c.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/c.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/c.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/c.poc.lh.cert.pem
cat /home/asd/_git/quick-ca/a.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/a.poc.lh.chain.pem
cat /home/asd/_git/quick-ca/b.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/b.poc.lh.chain.pem
cat /home/asd/_git/quick-ca/c.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/c.poc.lh.chain.pem
openssl genrsa -out /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem 4096
tee /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = *.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem
cat /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/wildcard.poc.lh.chain.pem
rm /home/asd/_git/quick-ca/c.poc.lh.v3.ext /home/asd/_git/quick-ca/a.poc.lh.csr.pem /home/asd/_git/quick-ca/a.poc.lh.csr.cnf /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf /home/asd/_git/quick-ca/c.poc.lh.csr.cnf /home/asd/_git/quick-ca/c.poc.lh.csr.pem /home/asd/_git/quick-ca/a.poc.lh.v3.ext /home/asd/_git/quick-ca/b.poc.lh.v3.ext /home/asd/_git/quick-ca/b.poc.lh.csr.cnf /home/asd/_git/quick-ca/b.poc.lh.csr.pem /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem
```

```
$ ls -1 *.pem
a.poc.lh.cert.pem
a.poc.lh.chain.pem
a.poc.lh.key.pem
b.poc.lh.cert.pem
b.poc.lh.chain.pem
b.poc.lh.key.pem
c.poc.lh.cert.pem
c.poc.lh.chain.pem
c.poc.lh.key.pem
poc.lh.cacert.pem
poc.lh.key.pem
wildcard.poc.lh.cert.pem
wildcard.poc.lh.chain.pem
wildcard.poc.lh.key.pem
```

### 3.4 Wildcard only

```
$ make HOSTS=
openssl genrsa -out /home/asd/_git/quick-ca/poc.lh.key.pem 4096
openssl req \
-x509 -new \
-nodes -key /home/asd/_git/quick-ca/poc.lh.key.pem \
-sha256 -days 4096 \
-out /home/asd/_git/quick-ca/poc.lh.cacert.pem <<< "$STDIN"
openssl genrsa -out /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem 4096
tee /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf <<< "$STDIN"
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
[dn]
C = PL
CN = *.poc.lh
openssl req \
-new \
-key /home/asd/_git/quick-ca/wildcard.poc.lh.key.pem \
-config /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem <<< "$STDIN"
tee /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext <<< "$STDIN"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:false
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.poc.lh
openssl x509 \
-req -in /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem \
-CAkey /home/asd/_git/quick-ca/poc.lh.key.pem -CA /home/asd/_git/quick-ca/poc.lh.cacert.pem -CAcreateserial \
-days 4096 -sha256 -extfile /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext \
-out /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem
cat /home/asd/_git/quick-ca/wildcard.poc.lh.cert.pem /home/asd/_git/quick-ca/poc.lh.cacert.pem > /home/asd/_git/quick-ca/wildcard.poc.lh.chain.pem
rm /home/asd/_git/quick-ca/wildcard.poc.lh.v3.ext /home/asd/_git/quick-ca/wildcard.poc.lh.csr.cnf /home/asd/_git/quick-ca/wildcard.poc.lh.csr.pem
```

```
$ ls -1 *.pem
poc.lh.cacert.pem
poc.lh.key.pem
wildcard.poc.lh.cert.pem
wildcard.poc.lh.chain.pem
wildcard.poc.lh.key.pem
```

### 3.5 Clean

**WARN: it removes everything!**

```
$ make clean
rm -f /home/asd/_git/quick-ca/*.pem /home/asd/_git/quick-ca/*.cnf /home/asd/_git/quick-ca/*.ext /home/asd/_git/quick-ca/*.srl
```

## 4. Default values

```make
HOSTS  ?= c1 c2 c3
DOMAIN ?= poc.lh

BITS ?= 4096
DAYS ?= 4096
```

## 5. License

`quick-ca` is licensed under the `Creative Commons Zero v1.0 Universal` license. See [LICENSE](./LICENSE).
