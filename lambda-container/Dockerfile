FROM public.ecr.aws/lambda/python:3.9

# Add the Lambda application to be run
WORKDIR ${LAMBDA_TASK_ROOT}

COPY app.py ${LAMBDA_TASK_ROOT}/app.py
COPY secrets.yaml ${LAMBDA_TASK_ROOT}/secrets.yaml

# Add an extension from the local directory into /opt
COPY --from=533973265978.dkr.ecr.eu-central-1.amazonaws.com/aws-lambda-secrets-extension:latest /extension/fetch-secrets /opt/extensions/fetch-secrets
COPY --from=533973265978.dkr.ecr.eu-central-1.amazonaws.com/aws-lambda-secrets-extension:latest /extension/wrapper/load-secrets /opt/extensions/wrapper/load-secrets

# Pass the actual ENTRYPOINT to 'lambda-secrets':

# Ensure 'lambda-secrets' runs BEFORE the Lambda application
# ENTRYPOINT ["/opt/extensions/wrapper/load-secrets"]

ENV AWS_LAMBDA_EXEC_WRAPPER "/opt/extensions/wrapper/load-secrets"

# - Cleaner and has priority:
CMD ["app.lambda_handler"]
# - Supports Shell notation such as pipes, loops
# ENV ENTRYPOINT "/app/lambda-application"