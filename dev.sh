#!/usr/bin/env bash
set -e
# set -x # Uncomment to debug

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${MY_DIR}"

if [ -f "${MY_DIR}/.env" ]; then
  eval "$(sed '/^$/d' "${MY_DIR}/.env"| sed -e 's/^/export /')"
fi

export PATH="${PATH}:${MY_DIR}/bin"

"${MY_DIR}/bin/setup-dependencies"

OSX="false"
if uname | grep -q Darwin; then
  OSX="true"
fi

DOCKER_IP='127.0.0.1'
if [ "$OSX" == "true" ]; then
  DOCKER_MACHINE_NAME="${DOCKER_MACHINE_NAME:-default}"
  if [ "Running" != "$(docker-machine status "${DOCKER_MACHINE_NAME}")" ]; then
    docker-machine start "${DOCKER_MACHINE_NAME}"
  fi
  DOCKER_IP="$(docker-machine ip "${DOCKER_MACHINE_NAME}")"
  eval "$(docker-machine env)"
fi

if [ ! -f "${MY_DIR}/Gemfile.md5" ]; then
  touch "${MY_DIR}/Gemfile.md5"
fi
if [ "${OSX}" == "true" ]; then
  MD5_SUM_COMMAND="md5 -q Gemfile"
else
  MD5_SUM_COMMAND="md5sum Gemfile | awk '{print \$1}'"
fi
${MD5_SUM_COMMAND} > "${MY_DIR}/Gemfile.md5.new"
if [ ! -z "$(diff -q "${MY_DIR}/Gemfile.md5" "${MY_DIR}/Gemfile.md5.new")" ]; then
  mv "${MY_DIR}/Gemfile.md5.new" "${MY_DIR}/Gemfile.md5"
  docker-compose build
fi

docker-compose up -d

WEB_PORT=$(docker-compose port web 3000 | sed -e 's|[\.0-9]*:||g')
DB_PORT=$(docker-compose port sql_db 5432 | sed -e 's|[\.0-9]*:||g')

echo "Use postgres://postgres:s3kr3t@${DOCKER_IP}:${DB_PORT}/identity_development to connect to your dev DB"

wait-for-it "${DOCKER_IP}:${WEB_PORT}" -s -t 30

WEB_URL="http://${DOCKER_IP}:${WEB_PORT}/"
if [ "$OSX" == "true" ]; then
  if [ -z "${BROWSER+x}" ]; then
    open "${WEB_URL}"
  else
    open -a "${BROWSER}" "${WEB_URL}"
  fi
else
  if [ ! -z "$(which xdg-open)" ]; then
    xdg-open "${WEB_URL}"
  elif [ ! -z "$(which x-www-browser)" ]; then
    x-www-browser "${WEB_URL}"
  else
    echo "Navigate using the following url: ${WEB_URL}"
  fi
fi

echo "Stop all services with Ctrl+C"
docker-compose up
