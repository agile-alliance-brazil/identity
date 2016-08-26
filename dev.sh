#!/usr/bin/env bash

bundle install

bundle exec foreman start -f Procfile.dev
