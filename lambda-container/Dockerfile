FROM public.ecr.aws/lambda/python:3.9

# Add the Lambda application to be run
WORKDIR ${LAMBDA_TASK_ROOT}

COPY app.py ${LAMBDA_TASK_ROOT}/app.py
COPY secrets.yaml ${LAMBDA_TASK_ROOT}/secrets.yaml

# Add extension into /opt/extensions
COPY --from=ghcr.io/skroutz/aws-lambda-secrets:v1.0.0 /extension/fetch-secrets /opt/extensions/fetch-secrets
COPY --from=ghcr.io/skroutz/aws-lambda-secrets:v1.0.0 /extension/wrapper/load-secrets /opt/extensions/wrapper/load-secrets

ENV AWS_LAMBDA_EXEC_WRAPPER "/opt/extensions/wrapper/load-secrets"

CMD ["app.lambda_handler"]