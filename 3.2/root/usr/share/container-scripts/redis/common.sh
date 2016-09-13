#!/bin/bash

source ${CONTAINER_SCRIPTS_PATH}/helpers.sh

# Data directory where MySQL database files live. The data subdirectory is here
# because .bashrc lives in /var/lib/mysql/ and we don't want a
# volume to override it.
export REDIS_DATADIR=/var/lib/redis/data

# Be paranoid and stricter than we should be.
redis_password_regex='^[a-zA-Z0-9_~!@#$%^&*()-=<>,.?;:|]+$'

# Make sure env variables don't propagate to mysqld process.
function unset_env_vars() {
  log_info 'Cleaning up environment variable REDIS_PASSWORD ...'
  unset REDIS_PASSWORD
}

# Comment out settings that we'll set in container specifically
function clear_config() {
  t=$(mktemp /tmp/XXXXXXXX)
  cat /etc/redis.conf | sed -e "s/^bind/#bind/" -e "s/^logfile/#logfile/" -e "s/^dir /#dir /" >$t
  cp $t /etc/redis.conf
  rm -f $t
}
