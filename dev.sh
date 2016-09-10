#!/usr/bin/env bash
set -e
# set -x # Uncomment to debug

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${MY_DIR}

${MY_DIR}/setup.sh

${MY_DIR}/bin/rake db:create db:migrate
RAILS_ENV=test ${MY_DIR}/bin/rake db:create db:migrate
${MY_DIR}/bin/bundle exec foreman start -f Procfile.dev
