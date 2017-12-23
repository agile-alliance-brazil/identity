FROM ruby:2.4.3
MAINTAINER sistemas@agilebrazil.com

WORKDIR /app
ENV HOME=/app PATH=/app/bin:$PATH
CMD ['rails', 'server', '-p', '3000']

RUN gem install bundler
COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor
RUN bundler install

COPY . ./
