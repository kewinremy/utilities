#!/bin/bash
CERTIFICATE_PEM=certificate.pem
CERTIFICATE_CRT=certificate.crt

# get certificate
echo -n | openssl s_client -showcerts -connect gitlab.sehlat.io:443 \
  2>/dev/null  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
  > $CERTIFICATE_PEM

# format certificate from PEM (human-readable) to CRT
openssl x509 -in $CERTIFICATE_PEM -out $CERTIFICATE_CRT

# move it to ca-certificates folder & update the bundle file
sudo mv ./$CERTIFICATE_CRT /usr/local/share/ca-certificates/
sudo update-ca-certificates

# configuring git
git config --global http.sslCAinfo /etc/ssl/certs/ca-certificates.crt
