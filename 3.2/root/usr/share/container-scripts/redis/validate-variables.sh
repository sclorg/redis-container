function usage() {
  [ $# == 1 ] && echo "error: $1"
  echo "You can specify the following environment variables:"
  echo "  REDIS_PASSWORD (regex: '$redis_password_regex')"
  exit 1
}

function validate_variables() {
  # Check basic sanity of specified variables
  if [[ -v REDIS_PASSWORD ]]; then
    [[ "$REDIS_PASSWORD" =~ $redis_password_regex   ]] || usage "Invalid password"
  fi
}

validate_variables
