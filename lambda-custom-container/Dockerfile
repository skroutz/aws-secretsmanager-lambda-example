FROM ruby:2.5

WORKDIR /var/task/

COPY Gemfile /var/task/
COPY Gemfile.lock /var/task/
COPY app.rb /var/task/

COPY secrets.yaml /var/task/secrets.yaml

RUN apt-get -y update \
    && apt-get install -qqy \
    build-essential \
    && gem install bundler -v 1.17.3 \
    && bundle install \
    && rm -rf /var/lib/apt/lists/*

ENV AWS_LAMBDA_RUNTIME_API=3.9

COPY --from=ghcr.io/skroutz/aws-lambda-secrets-extension:v1.0.0 /extension/fetch-secrets /opt/extensions/fetch-secrets
COPY --from=ghcr.io/skroutz/aws-lambda-secrets-extension:v1.0.0 /extension/wrapper/load-secrets /opt/extensions/wrapper/load-secrets

ENTRYPOINT [ "/opt/extensions/wrapper/load-secrets" ]
CMD [ "/usr/local/bundle/bin/aws_lambda_ric", "app.Lambdas::App.process"]
