#!/bin/sh

# DO NOT set -x, unless you want to print your credentials
set -e

_trust_keys() {
  for fpr in $(gpg --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u); do
    printf "5\ny\n" |  gpg --command-fd 0 --expert --edit-key "${fpr}" trust
  done
}

_import_or_generate_keys() {
  if [ "${PUB_KEY}" != "" ]; then
    # import existing key pair from environment variables
    printf "%s" "${PUB_KEY}" | base64 -d | gpg --import -
    printf "%s" "${SEC_KEY}" | base64 -d | gpg --allow-secret-key-import --import -

    _trust_keys
  elif [ -f "/data/pub.gpg" ]; then
    # import existing key pair from mounted file
    base64 -d "/data/pub.gpg" | gpg --import -
    base64 -d "/data/secret.gpg" | gpg --allow-secret-key-import --import -

    _trust_keys
  else
    # no key pair provided, generate and export
    gpg --generate-key --batch /opt/gpgparams

    gpg --armor -a --export | base64 -w 0 > /data/pub.gpg
    gpg --armor -a --export-secret-key | base64 -w 0 > /data/secret.gpg
  fi
}

credentials_dir="/home/proton/.password-store/protonmail-credentials"

_import_proton_bridge_credentials() {
  if [ "${CRED_DIR_NAME}" != "" ]; then
    # import credentials from environment variable
    mkdir -p "${credentials_dir}/${CRED_DIR_NAME}"
    if [ "${CRED_FILE_NAME}" != "" ]; then
      printf "%s" "${CRED_FILE_CONTENT}" | base64 -d > \
        "${credentials_dir}/${CRED_DIR_NAME}/${CRED_FILE_NAME}"
    fi
  elif [ -f "/data/cred_dirname.txt" ]; then
    # import credentials from file
    mkdir -p "${credentials_dir}/$(cat "/data/cred_dirname.txt")"
    cat "/data/cred.gpg" \
      > "${credentials_dir}/$(cat "/data/cred_dirname.txt")/$(cat "/data/cred_filename.txt")"
  fi
}

_start() {
  _import_or_generate_keys

  pass init "${KEY_ID:-"pass-key"}"

  _import_proton_bridge_credentials

  # Login
  do_login="proton-bridge --cli"
  if [ "${PROTONMAIL_USERNAME}" != "" ]; then
    # automated login if both username is set (implies password also set)
    do_login="login.exp ${do_login}"
  fi

  $do_login

  # save credential info to data dir
  if [ "${CRED_DIR_NAME}" = "" ] || [ "${CRED_FILE_NAME}" = "" ]; then
    cred_dirname="$(ls ${credentials_dir})"
    printf "%s" "${cred_dirname}" > "/data/cred_dirname.txt"

    cred_filename="$(ls "${credentials_dir}/${cred_dirname}")"
    printf "%s" "${cred_filename}" > "/data/cred_filename.txt"

    base64 -w 0 \
      "${credentials_dir}/${cred_dirname}/${cred_filename}" \
      > /data/cred.gpg
  fi

  # socat will make the conn appear to come from 127.0.0.1
  # ProtonMail Bridge currently expects that.
  # It also allows us to bind to the real ports :)
  socat TCP-LISTEN:9587,fork TCP:127.0.0.1:1025 &
  socat TCP-LISTEN:9143,fork TCP:127.0.0.1:1143 &

  # Start protonmail
  # Fake a terminal, so it does not quit because of EOF...
  fake_tty="$(mktemp -u)"
  mkfifo "${fake_tty}"

  echo "Starting proton-bridge..."
  exec cat "${fake_tty}" | proton-bridge --cli 2>&1
}

case "$1" in
start)
  _start
  ;;
*)
  # shellcheck disable=SC2068
  $@
  ;;
esac
