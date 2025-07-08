echo "Fetch the TrustedCA configmap from proxy/cluster"
# omc get proxy/cluster -o jsonpath='{.spec.trustedCA.name}'
PROXYCM=`omc get proxy/cluster -o jsonpath='{.spec.trustedCA.name}'`
omc get configmap $PROXYCM -n openshift-config -o jsonpath='{.data.ca-bundle\.crt}'
echo "Running openssl pkcs7 on the cm certificates"
#omc get configmap $PROXYCM -n openshift-config -o jsonpath='{.data.ca-bundle\.crt}'|openssl pkcs7 -print_certs -text -noout
omc get configmap user-ca-bundle -n openshift-config -o jsonpath='{.data.ca-bundle\.crt}' | sed 's/\\\\n/\\n/g' | xargs -0 printf "%b" >> ca-bundle.crt
openssl crl2pkcs7 -nocrl -certfile ca-bundle.crt | openssl pkcs7 -print_certs -noout
