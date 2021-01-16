#!/usr/bin/env bash

## my own rsync-based snapshot-style backup procedure
## (cc) marcio rps AT gmail.com

# NOTE: Please run script with sudo
# Also remember to copy ~./ssh to /root/

# config vars
# Fail as soon as a command fails
set -Eeuo pipefail

# Execute cleanup() if any of these sig events happen
trap cleanup SIGINT SIGTERM ERR #EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR #EXIT
  msg_error "==> Something went wrong..."
  read -n1 -r key
  exit $?
}

# Colors are only meant to be used with msg()
# Sample usage:
# msg "This is a ${RED}very important${NOFORMAT} message
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' \
      BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' \
      YELLOW='\033[1;33m' BOLD='\033[1m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW='' \
      BOLD=''
  fi
}

msg() {
  echo >&2 -e "${1-}${2-}${NOFORMAT}"
  # Skip pretty characters
  notify-send 'Rsync Mail Server' "${2}"
}
msg_error() {
  echo >&2 -e "${RED}${BOLD}${1-}${NOFORMAT}"
  notify-send 'Rsync Mail Server' "${1:4:-3}" -u critical
}

setup_colors

SRC="digital_ocean:/home/user-data/" #dont forget trailing slash!
# SNAP="/snapshots/username"
SNAP="$HOME/.mnt/skynfs/mailserver"
OPTS="-rltgoi -v --archive --delay-updates --delete --chmod=a-w 
  --copy-links --mkpath --relative -e 'ssh'"
MINCHANGES=20

# Mount homes if not mounted before
if ! [ "$(ls -A $SNAP)" ]; then
  # Ensure folder exists
  msg_error "==> Backup destination not available..."
  exit 1
  # TODO: Try to mount it
  # sudo mount -t cifs "$SKYWAFER" "$DIR" -o "$CIFS_OPTIONS"
  # mkdir -p "$SNAP"
fi

rsync $OPTS $SRC $SNAP/latest >>$SNAP/rsync.log

# check if enough has changed and if so
# make a hardlinked copy named as the date

COUNT=$(wc -l $SNAP/rsync.log | cut -d" " -f1)
if [ "$COUNT" -gt "$MINCHANGES" ]; then
  msg "${CYAN}${BOLD}" "==> [rsync_backup]: Creating new snapshot..."
  DATETAG=$(date +%Y-%m-%d)
  if [ ! -e $SNAP/$DATETAG ]; then
    cp -al $SNAP/latest $SNAP/$DATETAG
    chmod u+w $SNAP/$DATETAG
    mv $SNAP/rsync.log $SNAP/$DATETAG
    chmod u-w $SNAP/$DATETAG
  fi
fi
