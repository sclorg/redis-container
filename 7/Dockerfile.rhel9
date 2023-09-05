FROM ubi9/s2i-core:1

# Redis image based on Software Collections packages
#
# Volumes:
#  * /var/lib/redis/data - Datastore for Redis
# Environment:
#  * $REDIS_PASSWORD - Database password

ENV REDIS_VERSION=7 \
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
      name="rhel9/redis-$REDIS_VERSION" \
      version="1" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#rhel" \
      usage="podman run -d --name redis_database -p 6379:6379 rhel9/redis-$REDIS_VERSION" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

EXPOSE 6379

# Create user for redis that has known UID
# We need to do this before installing the RPMs which would create user with random UID
# The UID is the one used by the default user from the parent layer (1001),
# and since the user exists already, do not create a new one, but only rename
# the existing
# This image must forever use UID 1001 for redis user so our volumes are
# safe in the future. This should *never* change, the last test is there
# to make sure of that.
RUN getent group  redis &> /dev/null || groupadd -r redis &> /dev/null && \
    usermod -l redis -aG redis -c 'Redis Server' default &> /dev/null && \
# Install gettext for envsubst command
    yum -y module enable redis:$REDIS_VERSION && \
    INSTALL_PKGS="policycoreutils redis" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    redis-server --version | grep -qe "^Redis server v=$REDIS_VERSION\." && echo "Found VERSION $REDIS_VERSION" && \
    mkdir -p /var/lib/redis/data && chown -R redis.0 /var/lib/redis && \
    [[ "$(id redis)" == "uid=1001(redis)"* ]]

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis \
    REDIS_PREFIX=/usr \
    REDIS_CONF=/etc/redis/redis.conf

COPY root /

# this is needed due to issues with squash
# when this directory gets rm'd by the container-setup
# script.
RUN /usr/libexec/container-setup

VOLUME ["/var/lib/redis/data"]

# Using a numeric value because of a comment in [1]:
# If your S2I image does not include a USER declaration with a numeric user,
# your builds will fail by default.
# [1] https://docs.openshift.com/container-platform/4.4/openshift_images/create-images.html#images-create-guide-openshift_create-images
USER 1001

ENTRYPOINT ["container-entrypoint"]
CMD ["run-redis"]
