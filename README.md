Redis container image
=====================

[![Build and push images to Quay.io registry](https://github.com/sclorg/redis-container/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/sclorg/redis-container/actions/workflows/build-and-push.yml)

Images available on Quay are:
* CentOS Stream 9 [redis-6](https://quay.io/repository/sclorg/redis-6-c9s)
* Fedora [redis-6](https://quay.io/repository/fedora/redis-6)
* Fedora [redis-7](https://quay.io/repository/fedora/redis-7)

This repository contains Dockerfiles for Redis container image.
Users can choose between RHEL, Fedora and CentOS based images.

For more information about contributing, see
[the Contribution Guidelines](https://github.com/sclorg/welcome/blob/master/contribution.md).
For more information about concepts used in these container images, see the
[Landing page](https://github.com/sclorg/welcome).


Versions
--------
Redis version currently provided are:
* [redis-6](6)
* [redis-7](7)

RHEL versions currently supported are:
* RHEL7
* RHEL8
* RHEL9

CentOS versions currently supported are:
* CentOS Stream 9


Installation
------------
To build a Redis image, choose either the CentOS or RHEL based image:
*  **RHEL based image**

    These images are available in the [Red Hat Container Catalog](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/redis-6-rhel7).
    To download it run:

    ```
    $ podman pull registry.access.redhat.com/rhscl/redis-6-rhel7
    ```

    To build a RHEL based Redis image, you need to run the build on a properly
    subscribed RHEL machine.

    ```
    $ git clone --recursive https://github.com/sclorg/redis-container.git
    $ cd redis-container
    $ git submodule update --init
    $ make build TARGET=rhel7 VERSIONS=6
    ```

*  **CentOS Stream based image**

    This image is available on quay.io. To download it run:

    ```
    $ podman pull quay.io/sclorg/redis-7-c9s
    ```

    To build a Redis image from scratch run:

    ```
    $ git clone --recursive https://github.com/sclorg/redis-container.git
    $ cd redis-container
    $ git submodule update --init
    $ make build TARGET=c9s VERSIONS=7
    ```

Note: while the installation steps are calling `podman`, you can replace any such calls by `docker` with the same arguments.

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of Redis.**


Usage
-----

For information about usage of Dockerfile for Redis 6,
see [usage documentation](6).

Test
----
Users can choose between testing a Redis test application based on a RHEL or CentOS image.

*  **RHEL based image**

    To test a RHEL7 based Redis image, you need to run the test on a properly
    subscribed RHEL machine.

    ```
    $ cd redis-container
    $ git submodule update --init
    $ make test TARGET=rhel7 VERSIONS=6
    ```

*  **CentOS Stream based image**

    ```
    $ cd redis-container
    $ git submodule update --init
    $ make test TARGET=c9s VERSIONS=7
    ```

**Notice: By omitting the `VERSIONS` parameter, the build/test action will be performed
on all provided versions of Redis.**
