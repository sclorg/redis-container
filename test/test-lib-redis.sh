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

function test_redis_integration() {
  local image_name=$1
  local VERSION=$2
  local import_image=$3
  local service_name=${import_image##*/}
  ct_os_test_template_app_func "${image_name}" \
                               "https://raw.githubusercontent.com/openshift/origin/master/examples/db-templates/redis-ephemeral-template.json" \
                               "${service_name}" \
                               "ct_os_check_cmd_internal '${import_image}' '${service_name}' 'timeout 15 redis-cli -h <IP> -a testp ping' 'PONG'" \
                               "-p REDIS_VERSION=${VERSION} \
                                -p DATABASE_SERVICE_NAME="${service_name}-testing" \
                                -p REDIS_PASSWORD=testp" "" "${import_image}"
}

# vim: set tabstop=2:shiftwidth=2:expandtab:
