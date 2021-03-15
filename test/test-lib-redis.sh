#!/bin/bash
#
# Functions for tests for the Redis image in OpenShift.
#
# IMAGE_NAME specifies a name of the candidate image used for testing.
# The image has to be available before this script is executed.
#

THISDIR=$(dirname ${BASH_SOURCE[0]})

source ${THISDIR}/test-lib.sh
source ${THISDIR}/test-lib-openshift.sh
source ${THISDIR}/test-lib-remote-openshift.sh

function test_redis_integration() {
  local image_name=$1
  local service_name=redis
  ct_os_test_template_app_func "${image_name}" \
                               "https://raw.githubusercontent.com/openshift/origin/master/examples/db-templates/redis-ephemeral-template.json" \
                               "${service_name}" \
                               "ct_os_check_cmd_internal '<SAME_IMAGE>' '${service_name}-testing' 'timeout 15 redis-cli -h <IP> -a testp ping' 'PONG'" \
                               "-p REDIS_VERSION=${VERSION} \
                                -p DATABASE_SERVICE_NAME="${service_name}-testing" \
                                -p REDIS_PASSWORD=testp"
}

# Check the imagestream
function test_redis_imagestream() {
  case ${OS} in
    rhel7|centos7) ;;
    *) echo "Imagestream testing not supported for $OS environment." ; return 0 ;;
  esac

  ct_os_test_image_stream_template "${THISDIR}/../imagestreams/redis-${OS%[0-9]*}.json" "${THISDIR}/../examples/redis-ephemeral-template.json" redis "-p REDIS_VERSION=${VERSION}"
}

# vim: set tabstop=2:shiftwidth=2:expandtab:
