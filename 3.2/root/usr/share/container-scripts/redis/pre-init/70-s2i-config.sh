S2I_REDIS_CONFIG=${S2I_REDIS_CONFIG:-${APP_DATA}/redis-cfg/redis.conf}

if [ -f ${S2I_REDIS_CONFIG} ]; then
    log_info '---> Found s2i provided config, including it...'
    S2I_REDIS_CONFIG=${S2I_REDIS_CONFIG} envsubst < ${CONTAINER_SCRIPTS_PATH}/cfg/s2i-config.conf.template >> /etc/redis.conf
fi

