#!/bin/sh -x
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048

openssl rsa -passin pass:x -in server.pass.key -out server.key

rm server.pass.key

openssl req -new -key server.key -out server.csr -subj "/C=IN/ST=Maharashtra/L=Pune/O=IDMWorks/OU=IdentityForge/CN=localhost"

openssl x509 -req -sha256 -extfile v3.ext -days 365 -in server.csr -signkey server.key -out server.crt


openssl pkcs12 -export -name servercert -in server.crt -inkey server.key -out myp12keystore.p12 -password pass:changeme

keytool -importkeystore -destkeystore keystore.jks \
-srckeystore myp12keystore.p12 -srcstoretype pkcs12 \
-srcstorepass changeme -alias servercert -storepass changeme -keypass changeme

keytool -list -rfc --keystore keystore.jks -storepass changeme | openssl x509 -inform pem -pubkey -noout > ./user-api/src/main/resources/public.txt

mv keystore.jks ./auth-server/src/main/resources

rm server.key server.csr server.crt myp12keystore.p12

