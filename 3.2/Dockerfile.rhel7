FROM rhscl/s2i-core-rhel7

# Redis image based on Software Collections packages
#
# Volumes:
#  * /var/lib/redis/data - Datastore for Redis
# Environment:
#  * $REDIS_PASSWORD - Database password

ENV REDIS_VERSION=3.2 \
    HOME=/var/lib/redis

ENV SUMMARY="Redis in-memory data structure store, used as database, cache and message broker" \
    DESCRIPTION="Redis $REDIS_VERSION available as container, is an advanced key-value store. \
It is often referred to as a data structure server since keys can contain strings, hashes, lists, \
sets and sorted sets. You can run atomic operations on these types, like appending to a string; \
incrementing the value in a hash; pushing to a list; computing set intersection, union and difference; \
or getting the member with highest ranking in a sorted set. In order to achieve its outstanding \
performance, Redis works with an in-memory dataset. Depending on your use case, you can persist \
it either by dumping the dataset to disk every once in a while, or by appending each command to a log."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Redis 3.2" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="database,redis,redis32,rh-redis32" \
      com.redhat.component="rh-redis32-container" \
      name="rhscl/redis-32-rhel7" \
      version="3.2" \
      usage="docker run -d --name redis_database -p 6379:6379 rhscl/redis-32-rhel7" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

EXPOSE 6379

# Create user for redis that has known UID
# We need to do this before installing the RPMs which would create user with random UID
RUN getent group  redis &> /dev/null || groupadd -r redis &> /dev/null && \
    usermod -l redis -g redis -c 'Redis Server' default &> /dev/null && \
# Install gettext for envsubst command
# This image must forever use UID 964 for redis user so our volumes are
# safe in the future. This should *never* change, the last test is there
# to make sure of that.
    yum install -y yum-utils gettext && \
    prepare-yum-repositories rhel-server-rhscl-7-rpms && \
    INSTALL_PKGS="rh-redis32" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/redis/data && chown -R redis.0 /var/lib/redis

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis \
    REDIS_PREFIX=/opt/rh/rh-redis32/root/usr \
    ENABLED_COLLECTIONS=rh-redis32

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

COPY root /

# this is needed due to issues with squash
# when this directory gets rm'd by the container-setup
# script.
RUN /usr/libexec/container-setup

VOLUME ["/var/lib/redis/data"]

USER 1001

ENTRYPOINT ["container-entrypoint"]
CMD ["run-redis"]
