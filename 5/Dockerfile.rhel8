FROM rhel8/s2i-core

# Redis image based on Software Collections packages
#
# Volumes:
#  * /var/lib/redis/data - Datastore for Redis
# Environment:
#  * $REDIS_PASSWORD - Database password

ENV REDIS_VERSION=5 \
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
      io.k8s.display-name="Redis $REDIS_VERSION" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="database,redis,redis$REDIS_VERSION,redis-$REDIS_VERSION" \
      com.redhat.component="redis-$REDIS_VERSION-container" \
      name="rhel8/redis-$REDIS_VERSION" \
      version="1" \
      usage="podman run -d --name redis_database -p 6379:6379 rhel8/redis-$REDIS_VERSION" \
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
    yum -y module enable redis:$REDIS_VERSION && \
    INSTALL_PKGS="policycoreutils redis" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/redis/data && chown -R redis.0 /var/lib/redis

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis \
    REDIS_PREFIX=/usr

COPY root /

# this is needed due to issues with squash
# when this directory gets rm'd by the container-setup
# script.
RUN /usr/libexec/container-setup

VOLUME ["/var/lib/redis/data"]

USER 1001

ENTRYPOINT ["container-entrypoint"]
CMD ["run-redis"]
