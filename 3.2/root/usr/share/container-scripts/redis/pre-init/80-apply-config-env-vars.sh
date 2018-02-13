if [[ -v REDIS_PASSWORD ]]; then
  envsubst < ${CONTAINER_SCRIPTS_PATH}/cfg/password.conf.template >> /etc/redis.conf
else
  log_info 'WARNING: setting REDIS_PASSWORD is recommended'
fi

