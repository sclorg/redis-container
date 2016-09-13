Redis Docker image
====================

This container image includes Dockerfile for Redis 3.2 Docker image.
Users can choose between RHEL and CentOS based images.

Dockerfile for CentOS is called Dockerfile, Dockerfile for RHEL is called
Dockerfile.rhel7.

Environment variables and volumes
----------------------------------

|    Variable name       |    Description                            |
| :--------------------- | ----------------------------------------- |
|  `REDIS_PASSWORD`      | Password for the server access            |

TBD

You can also set the following mount points by passing the `-v /host:/container:Z` flag to Docker.

|  Volume mount point      | Description          |
| :----------------------- | -------------------- |
|  `/var/lib/redis/data`   | Redis data directory |

**Notice: When mouting a directory from the host into the container, ensure that the mounted
directory has the appropriate permissions and that the owner and group of the directory
matches the user UID or name which is running inside the container.**

Usage
---------------------------------

For this, we will assume that you are using the `rhscl/redis-32-rhel7` image.
If you want to set only the mandatory environment variables and not store
the database in a host directory, execute the following command:

```
$ docker run -d --name redis_database 6379:6379 rhscl/redis-32-rhel7
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
