#!/bin/bash

source ${CONTAINER_SCRIPTS_PATH}/helpers.sh

# Data directory where Redis database files live. The data subdirectory is here
# because .bashrc lives in /var/lib/redis/ and we don't want a
# volume to override it.
export REDIS_DATADIR=/var/lib/redis/data

# Be paranoid and stricter than we should be.
redis_password_regex='^[a-zA-Z0-9_~!@#$%^&*()-=<>,.?;:|]+$'

# Make sure env variables don't propagate to redis process.
function unset_env_vars() {
  log_info 'Cleaning up environment variable REDIS_PASSWORD ...'
  unset REDIS_PASSWORD
}

# Comment out settings that we'll set in container specifically
function clear_config() {
  sed -e "s/^bind/#bind/" \
      -e "s/^logfile/#logfile/" \
      -e "s/^dir /#dir /" \
      -e "/^protected-mode/s/yes/no/" \
      -i "${REDIS_CONF}"
}

function setup_bind_address() {
  # Function sets bind
  if [[ -v BIND_ADDRESS ]]; then
    log_info "Configuring redis to listen on $BIND_ADDRESS only ..."
    echo "bind $BIND_ADDRESS" >> "${REDIS_CONF}"
  fi
}
