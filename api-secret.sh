APISECRET=`omc get apiserver cluster -o jsonpath='{.spec.servingCerts.namedCertificates[*].servingCertificate.name}'`
omc get secret $APISECRET -n openshift-config -o jsonpath='{.data.tls\.crt}' | base64 -d > api.crt
openssl x509 -in api.crt -noout -issuer -subject -startdate -enddate -text | grep -E "Issuer:|Subject:|Not Before:|Not After :|CA:"
