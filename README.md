Redis container image
==================

This repository contains Dockerfiles for Redis container image.
Users can choose between RHEL, Fedora and CentOS based images.

For more information about contributing, see
[the Contribution Guidelines](https://github.com/sclorg/welcome/blob/master/contribution.md).
For more information about concepts used in these container images, see the
[Landing page](https://github.com/sclorg/welcome).


Versions
---------------
Redis versions currently provided are:
* [redis-3.2](3.2)
* [redis-5](5)

RHEL versions currently supported are:
* RHEL7
* RHEL8

CentOS versions currently supported are:
* CentOS7


Installation
---------------
To build a Redis image, choose either the CentOS or RHEL based image:
*  **RHEL based image**

    These images are available in the [Red Hat Container Catalog](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/redis-32-rhel7).
    To download it run:

    ```
    $ podman pull registry.access.redhat.com/rhscl/redis-32-rhel7
    ```

    To build a RHEL based Redis image, you need to run the build on a properly
    subscribed RHEL machine.

    ```
    $ git clone --recursive https://github.com/sclorg/redis-container.git
    $ cd redis-container
    $ git submodule update --init
    $ make build TARGET=rhel7 VERSIONS=3.2
    ```

*  **CentOS based image**

    This image is available on DockerHub. To download it run:

    ```
    $ podman pull centos/redis-32-centos7
    ```

    To build a Redis image from scratch run:

    ```
    $ git clone --recursive https://github.com/sclorg/redis-container.git
    $ cd redis-container
    $ git submodule update --init
    $ make build TARGET=centos7 VERSIONS=3.2
    ```

Note: while the installation steps are calling `podman`, you can replace any such calls by `docker` with the same arguments.

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of Redis.**


Usage
---------------------------------

For information about usage of Dockerfile for Redis 3.2,
see [usage documentation](3.2).

For information about usage of Dockerfile for Redis 5,
see [usage documentation](5).

Test
---------------------
Users can choose between testing a Redis test application based on a RHEL or CentOS image.

*  **RHEL based image**

    To test a RHEL7 based Redis image, you need to run the test on a properly
    subscribed RHEL machine.

    ```
    $ cd redis-container
    $ git submodule update --init
    $ make test TARGET=rhel7 VERSIONS=3.2
    ```

*  **CentOS based image**

    ```
    $ cd redis-container
    $ git submodule update --init
    $ make test TARGET=centos7 VERSIONS=3.2
    ```

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of Redis.**
