#!/bin/bash
#
# Functions for tests for the Redis image in OpenShift.
#
# IMAGE_NAME specifies a name of the candidate image used for testing.
# The image has to be available before this script is executed.
#

THISDIR=$(dirname ${BASH_SOURCE[0]})

source "${THISDIR}/test-lib.sh"
source "${THISDIR}/test-lib-openshift.sh"
source "${THISDIR}/test-lib-remote-openshift.sh"

function test_redis_integration() {
  local service_name=redis
  if [ "${OS}" == "rhel7" ]; then
    namespace_image="rhscl/redis-${VERSION}-rhel7"
  else
    namespace_image="${OS}/redis-${VERSION}"
  fi
  TEMPLATES="redis-ephemeral-template.json
  redis-persistent-template.json"
  for template in $TEMPLATES; do
    ct_os_test_template_app_func "${IMAGE_NAME}" \
                               "${THISDIR}/examples/${template}" \
                               "${service_name}" \
                               "ct_os_check_cmd_internal 'registry.redhat.io/${namespace_image}' '${service_name}-testing' 'timeout 15 redis-cli -h <IP> -a testp ping' 'PONG'" \
                               "-p REDIS_VERSION=${VERSION} \
                                -p DATABASE_SERVICE_NAME="${service_name}-testing" \
                                -p REDIS_PASSWORD=testp"
  done
}

# Check the imagestream
function test_redis_imagestream() {
  if [ "${VERSION}" == "7" ]; then
    echo "Skipping testing version. It is not generally available yet."
    return 0
  fi
  local tag="-el7"
  if [ "${OS}" == "rhel8" ]; then
    tag="-el8"
  elif [ "${OS}" == "rhel9" ]; then
    tag="-el9"
  fi
  TEMPLATES="redis-ephemeral-template.json
  redis-persistent-template.json"
  for template in $TEMPLATES; do
    ct_os_test_image_stream_template "${THISDIR}/imagestreams/redis-${OS%[0-9]*}.json" "${THISDIR}/examples/${template}" redis "-p REDIS_VERSION=${VERSION}${tag}"
  done
}

function test_latest_imagestreams() {
  info "Testing the latest version in imagestreams"
  # Switch to root directory of a container
  pushd "${THISDIR}/../.." >/dev/null
  ct_check_latest_imagestreams
  popd >/dev/null
}

# vim: set tabstop=2:shiftwidth=2:expandtab:
