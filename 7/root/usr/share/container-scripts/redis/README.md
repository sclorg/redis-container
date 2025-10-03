Redis 7 in-memory data structure store container image
======================================================

This container image includes Redis 7 in-memory data structure store for OpenShift and general usage.
Users can choose between RHEL, CentOS Stream, and Fedora based images.
The RHEL images are available in the [Red Hat Container Catalog](https://access.redhat.com/containers/),
the CentOS Stream images are available on [Quay.io](https://quay.io/organization/sclorg),
and the Fedora images are available in [Fedora Registry](https://quay.io/organization/fedora).
The resulting image can be run using [podman](https://github.com/containers/libpod).

Note: while the examples in this README are calling `podman`, you can replace any such calls by `docker` with the same arguments

Description
-----------

Redis 7 available as container, is an advanced key-value store.
It is often referred to as a data structure server since keys can contain strings, hashes, lists,
sets and sorted sets. You can run atomic operations on these types, like appending to a string;
incrementing the value in a hash; pushing to a list; computing set intersection, union and difference;
or getting the member with highest ranking in a sorted set. In order to achieve its outstanding
performance, Redis works with an in-memory dataset. Depending on your use case, you can persist
it either by dumping the dataset to disk every once in a while, or by appending each command to a log.


Usage
-----

For this, we will assume that you are using the `rhel9/redis-7` image.
If you want to set only the mandatory environment variables and not store
the database in a host directory, execute the following command:

```
$ podman run -d --name redis_database -p 6379:6379 rhel9/redis-7
```

This will create a container named `redis_database`. Port 6379 will be exposed and mapped
to the host.

If you want your database to be persistent across container executions, also add a
`-v /host/db/path:/var/lib/redis/data:Z` argument. This will be the Redis data directory.

For protecting Redis data by a password, pass `REDIS_PASSWORD` environment variable
to the container like this:

```
$ podman run -d --name redis_database -e REDIS_PASSWORD=strongpassword rhel9/redis-7
```

**Warning: since Redis is pretty fast an outside user can try up to
150k passwords per second against a good box. This means that you should
use a very strong password otherwise it will be very easy to break.**


Environment variables and volumes
----------------------------------

**`REDIS_PASSWORD`**  
       Password for the server access

**`BIND_ADDRESS`**
       IP address for the server to listen on


You can also set the following mount points by passing the `-v /host:/container:Z` flag to podman.

**`/var/lib/redis/data`**  
       Redis data directory


**Notice: When mouting a directory from the host into the container, ensure that the mounted
directory has the appropriate permissions and that the owner and group of the directory
matches the user UID or name which is running inside the container.**


Troubleshooting
---------------
Redis logs into standard output, so the log is available in the container log. The log can be examined by running:

    podman logs <container>


See also
--------
Dockerfile and other sources for this container image are available on
https://github.com/sclorg/redis-container.
In that repository you also can find another versions of Python environment Dockerfiles.
Dockerfile for RHEL8 it's `Dockerfile.rhel8`, for RHEL9 it's `Dockerfile.rhel9`,
for CentOS Stream 9 it's `Dockerfile.c9s` and the Fedora Dockerfile is called Dockerfile.fedora.
