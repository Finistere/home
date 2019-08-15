# Connect to keychain
if [ -x "$(command -v keychain)" ]; then
  eval `keychain --quiet --eval id_rsa`
  . ~/.keychain/${HOSTNAME}-sh
  . ~/.keychain/${HOSTNAME}-sh-gpg
fi

