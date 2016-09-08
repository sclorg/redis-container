Redis Docker image
====================

This container image includes Dockerfile for Redis 3.2 Docker image.
Users can choose between RHEL and CentOS based images.

Dockerfile for CentOS is called Dockerfile, Dockerfile for RHEL is called
Dockerfile.rhel7.

Environment variables and volumes
----------------------------------

TBD

You can also set the following mount points by passing the `-v /host:/container` flag to Docker.

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
to the host. If you want your database to be persistent across container executions,
also add a `-v /host/db/path:/var/lib/redis` argument. This will be the Redis
data directory.

