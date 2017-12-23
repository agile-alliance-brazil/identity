FROM ruby:2.4.3
MAINTAINER sistemas@agilebrazil.com

WORKDIR /app
ENV HOME=/app PATH=/app/bin:$PATH
CMD [ "bundler", "exec", "puma", "--bind", "tcp://0.0.0.0:3000" ]
EXPOSE 3000

RUN gem install bundler
COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor
RUN bundler install  --without development test

COPY . ./

USER nobody
