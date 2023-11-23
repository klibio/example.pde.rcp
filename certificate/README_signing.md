# code signing

for demonstration purposes we use a self-signed code signing certificate

execution file `cert.sh` will generate

* a keystore `mykeystore.jks`with a private key and certificate
* a property file `sign.properties`

build process is consuming the `sign.properties`