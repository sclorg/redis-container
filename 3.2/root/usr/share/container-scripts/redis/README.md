Redis 3.2 in-memory data structure store Docker image
====================

This container image includes Redis 3.2 in-memory data structure store for OpenShift and general usage.
Users can choose between RHEL and CentOS based images.
The RHEL image is available in the [Red Hat Container Catalog](https://access.redhat.com/#/registry.access.redhat.com/rhscl/redis-32-rhel7)
as registry.access.redhat.com/rhscl/redis-32-rhel7.
The CentOS image is then available on [Docker Hub](https://hub.docker.com/r/centos/redis-32-centos7/)
as centos/redis-32-centos7.


Description
-----------

Redis 3.2 available as docker container, is an advanced key-value store. 
It is often referred to as a data structure server since keys can contain strings, hashes, lists, 
sets and sorted sets. You can run atomic operations on these types, like appending to a string; 
incrementing the value in a hash; pushing to a list; computing set intersection, union and difference; 
or getting the member with highest ranking in a sorted set. In order to achieve its outstanding 
performance, Redis works with an in-memory dataset. Depending on your use case, you can persist 
it either by dumping the dataset to disk every once in a while, or by appending each command to a log.


Usage
-----

For this, we will assume that you are using the `rhscl/redis-32-rhel7` image.
If you want to set only the mandatory environment variables and not store
the database in a host directory, execute the following command:

```
$ docker run -d --name redis_database -p 6379:6379 rhscl/redis-32-rhel7
```

This will create a container named `redis_database`. Port 6379 will be exposed and mapped
to the host.

If you want your database to be persistent across container executions, also add a
`-v /host/db/path:/var/lib/redis/data:Z` argument. This will be the Redis data directory.

For protecting Redis data by a password, pass `REDIS_PASSWORD` environment variable
to the container like this:

```
$ docker run -d --name redis_database -e REDIS_PASSWORD=strongpassword rhscl/redis-32-rhel7
```

**Warning: since Redis is pretty fast an outside user can try up to
150k passwords per second against a good box. This means that you should
use a very strong password otherwise it will be very easy to break.**


Environment variables and volumes
----------------------------------

**`REDIS_PASSWORD`**  
       Password for the server access


You can also set the following mount points by passing the `-v /host:/container:Z` flag to Docker.

**`/var/lib/redis/data`**  
       Redis data directory


**Notice: When mouting a directory from the host into the container, ensure that the mounted
directory has the appropriate permissions and that the owner and group of the directory
matches the user UID or name which is running inside the container.**


Extending image
---------------
This image can be extended using [source-to-image](https://github.com/openshift/source-to-image).

For example, to build a customized redis database image `my-redis-rhel7`
with a configuration in `~/image-configuration/` run:

```
$ s2i build ~/image-configuration/ rhscl/redis-32-rhel7 my-redis-rhel7
```

The directory passed to `s2i build` can contain these directories:

`redis-cfg/`
    When starting the container, `redis.config` file from this directory will be imported in
    a configuration for the `redis-server` daemon.
    `envsubst` command is run on this file to still allow customization of
    the image using environmental variables.

`redis-pre-init/`
    Contained shell scripts (`*.sh`) are sourced in alphabetical order every start before volume gets initialised and local daemon starts. If you pass any script with the same name as builtin one, builtin one gets overrided allowing you to modify default container behavior.

`redis-start/`
    Contained shell scripts (`*.sh`) are sourced in alphabetical order every start after volume has been initialised and local daemon is running without password. If you pass any script with the same name as builtin one, builtin one gets overrided allowing you to modify default container behavior.


Troubleshooting
---------------
Redis logs into standard output, so the log is available in the container log. The log can be examined by running:

    docker logs <container>


See also
--------
Dockerfile and other sources for this container image are available on
https://github.com/sclorg/redis-container.
In that repository, Dockerfile for CentOS is called Dockerfile, Dockerfile
for RHEL is called Dockerfile.rhel7 and Dockerfile for Fedora is called Dockerfile.fedora.

