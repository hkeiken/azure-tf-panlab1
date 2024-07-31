# If you might use the bundle for different users this path should be readable by most
#TMP_CERT=/usr/local/shared-ca-bundle.pem
TMP_CERT=$HOME/my-ca-bundle.pem
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > $TMP_CERT
security find-certificate -a -p /Library/Keychains/System.keychain >> $TMP_CERT
## If you have a internal company proxy cert (Root CA usually), append it to the .pem file if it wasn't in the system stores
## This adds the variable to your shell config file
echo 'export REQUESTS_CA_BUNDLE="$HOME/my-ca-bundle.pem"' >> $HOME/.bash_profile
echo 'export REQUESTS_CA_BUNDLE="$HOME/my-ca-bundle.pem"' >> $HOME/.zshrc
. $HOME/.bash_profile # this loads the variable to the current shell environment
# run your `pip install whatever` or
# `az upgrade` or `az bicep install`
### the Azure CLI is built with Python and uses it for the plugins they use

