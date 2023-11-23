#!/bin/bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ts=$(date +"%Y%m%d_%H%M%S")

# Configuration
sign_propfile="sign.properties"
CERT_ALIAS="mycert"
CERT_DNAME="/CN=Company/OU=OrgUnit/O=Org/L=City/ST=State/C=DE/"
CERT_VALIDITY=365 # days
KEYSTORE_NAME="mykeystore.jks"
KEYSTORE_PASSWORD="changeit"

cd $script_dir
rm $KEYSTORE_NAME $sign_propfile >/dev/null 2>&1
# Generate a private key
openssl genpkey -algorithm RSA -out myprivate.key

# Generate a self-signed certificate
MSYS_NO_PATHCONV=1 openssl req -new -x509 -key myprivate.key -out mycertificate.crt -days $CERT_VALIDITY -subj "$CERT_DNAME"

# Convert the certificate to DER format
openssl x509 -outform der -in mycertificate.crt -out mycertificate.der

# Convert private key to PKCS12 format (includes the certificate)
openssl pkcs12 -export -in mycertificate.crt -inkey myprivate.key -out keystore.p12 -name $CERT_ALIAS -password pass:$KEYSTORE_PASSWORD

# Create or update Java KeyStore with PKCS12 keystore
keytool -importkeystore -deststorepass $KEYSTORE_PASSWORD -destkeystore $KEYSTORE_NAME -srckeystore keystore.p12 -srcstoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD -alias $CERT_ALIAS

# Clean up temporary files (optional)
rm myprivate.key mycertificate.crt mycertificate.der keystore.p12
cat > $sign_propfile <<- EOM
# generated from cert.sh at $ts
sign_skip=false
sign_keystore=$KEYSTORE_NAME
sign_alias=$CERT_ALIAS
sign_storepass=$KEYSTORE_PASSWORD
sign_keypass=$KEYSTORE_PASSWORD
EOM


echo "Self-signed certificate added to keystore '$KEYSTORE_NAME' with alias '$CERT_ALIAS'"
