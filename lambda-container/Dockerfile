FROM public.ecr.aws/lambda/ruby:2.7

# Add the Lambda application to be run
WORKDIR /app
COPY lambda-application /app/lambda-application

# == Setup 'lambda-secrets' ==
# Add 'lambda-secrets' binary from Container Image
# COPY --from=lambda-secrets:latest /app/lambda-secrets /app/lambda-secrets
COPY lambda-secrets /app/lambda-secrets
COPY secrets.yaml /app/secrets.yaml

# Pass the actual ENTRYPOINT to 'lambda-secrets':

# Ensure 'lambda-secrets' runs BEFORE the Lambda application
ENTRYPOINT ["/app/lambda-secrets"]

# - Cleaner and has priority:
CMD ["/app/lambda-application"]
# - Supports Shell notation such as pipes, loops
# ENV ENTRYPOINT "/app/lambda-application"