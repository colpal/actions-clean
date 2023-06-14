FROM public.ecr.aws/docker/library/alpine:3.13.2
RUN apk add --no-cache bash docker-cli jq
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
