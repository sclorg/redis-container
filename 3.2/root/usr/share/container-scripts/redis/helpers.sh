# Constants used for waiting
readonly MAX_ATTEMPTS=60
readonly SLEEP_TIME=1
function log_info {
  echo "---> `date +%T`     $@"
}

function log_and_run {
  log_info "Running $@"
  "$@"
}

function log_volume_info {
  CONTAINER_DEBUG=${CONTAINER_DEBUG:-}
  if [[ "${CONTAINER_DEBUG,,}" != "true" ]]; then
    return
  fi

  log_info "Volume info for $@:"
  set +e
  log_and_run mount
  while [ $# -gt 0 ]; do
    log_and_run ls -alZ $1
    shift
  done
  set -e
}

# get_matched_files finds file for image extending
function get_matched_files() {
  local custom_dir default_dir
  custom_dir="$1"
  default_dir="$2"
  files_matched="$3"
  find "$default_dir" -maxdepth 1 -type f -name "$files_matched" -printf "%f\n"
  [ -d "$custom_dir" ] && find "$custom_dir" -maxdepth 1 -type f -name "$files_matched" -printf "%f\n"
}

# process_extending_files process extending files in $1 and $2 directories
# - source all *.sh files
#   (if there are files with same name source only file from $1)
function process_extending_files() {
  local custom_dir default_dir
  custom_dir=$1
  default_dir=$2

  if ! [ -d $default_dir ]; then
    echo "$default_dir does not exist. Exiting..."
    return 1
  fi

  while read filename ; do
    echo "=> sourcing $filename ..."
    # Custom file is prefered
    if [ -f $custom_dir/$filename ]; then
      source $custom_dir/$filename
#    elif [ -f $default_dir/$filename ]; then
    else
      if [[ -n $filename ]]; then
        source $default_dir/$filename
      fi
    fi
  done <<<"$(get_matched_files "$custom_dir" "$default_dir" '*.sh' | sort -u)"
}

# wait_for_redis waits until the redis server is up/down
# $1 - 0 or 1 - to specify for what to wait (0 - down, 1 - up)
function _wait_for_redis() {
  local operation=${1:-1}
  local message="up"
  if [[ ${operation} -eq 0 ]]; then
    message="down"
  fi

  local i
  for i in $(seq $MAX_ATTEMPTS); do
    echo "=> ${2:-} Waiting for Redis daemon ${message}"
    if ([[ ${operation} -eq 1 ]] && redis-cli get something &>/dev/null) || ([[ ${operation} -eq 0 ]] && ! redis-cli get something &>/dev/null); then
      echo "=> Redis daemon is ${message}"
      return 0
    fi
    sleep ${SLEEP_TIME}
  done
  echo "=> Giving up: Redis daemon is not ${message}!"
  return 1
}

# wait_for_redis_up waits until the redis server accepts incomming connections
function wait_for_redis_up() {
  _wait_for_redis 1 "$@"
}

# wait_for_redis_down waits until the redis server is down
function wait_for_redis_down() {
  _wait_for_redis 0 "$@"
}

