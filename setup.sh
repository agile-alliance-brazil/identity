#!/usr/bin/env bash
set -e
# set -x # Uncomment to debug

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${MY_DIR}

if [[ -z `which ruby` ]]; then
  echo "Missing ruby in your path. Please install the correct version and try again" && exit 1
fi

if [[ -z `which gem` ]]; then
  echo "Missing rubygems in your path. Please install the correct version and try again" && exit 1
fi

if [[ -z `which bundle` ]]; then
  echo "Installing bundler..."
  gem --version &> /dev/null && gem install bundler &> /dev/null
fi

OSX="false"
if [[ -n `uname -a | grep Darwin` ]]; then
  OSX="true"
fi

if [[ ${OSX} == "true" ]] && [[ -z `which brew` ]]; then
  echo "Installing brew. This will ask for your password..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ ${OSX} == "false" ]] && [[ -z `which apt-get` ]]; then
  echo "This setup is only ready for apt-get based linuxes and OSX. You'll have to open and edit this file to fix it for your distribution."
  exit 1
fi

if [[ -z `which phantomjs` ]]; then
  echo "Installing phantomjs..."
  if [[ ${OSX} == "true" ]]; then
    (brew --version &> /dev/null && brew install phantomjs &> /dev/null)
  fi
  if [[ ${OSX} == "false" ]]; then
    (sudo apt-get --version &> /dev/null && sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev &> /dev/null)
    PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
    curl -s https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 > /tmp/$PHANTOM_JS.tar.bz2
    cd /tmp
    tar xvjf $PHANTOM_JS.tar.bz2
    sudo mv $PHANTOM_JS /usr/local/share
    sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
    cd -
  fi
fi

${MY_DIR}/bin/bundle install
