FROM nginx:alpine
LABEL maintainer="zzswang@gmail.com"

ENV DEBUG=off \
  BUILD="1997-01-01T00:00:00.000Z" \
  APP_VERSION="v0.0.0" \
  APP_WORKDIR=/app \
  APP_BASENAME=/aSubSiteInParentDomainUseThisPath \
  API_PLACEHOLDER=/allRequestStartOfthisPathIsAnApiCall \
  API_GATEWAY="https://api.adventurer.tech" \
  API_PLACEHOLDER_1=/allRequestStartOfthisPathIsAnApiCall_1 \
  API_GATEWAY_1="https://api.adventurer.tech" \
  API_PLACEHOLDER_2=/allRequestStartOfthisPathIsAnApiCall_2 \
  API_GATEWAY_2="https://api.adventurer.tech" \
  API_PLACEHOLDER_3=/allRequestStartOfthisPathIsAnApiCall_3 \
  API_GATEWAY_3="https://api.adventurer.tech" \
  API_PLACEHOLDER_4=/allRequestStartOfthisPathIsAnApiCall_4 \
  API_GATEWAY_4="https://api.adventurer.tech" \
  API_PLACEHOLDER_5=/allRequestStartOfthisPathIsAnApiCall_5 \
  API_GATEWAY_5="https://api.adventurer.tech" \
  CLIENT_BODY_TIMEOUT=10 \
  CLIENT_HEADER_TIMEOUT=10 \
  CLIENT_MAX_BODY_SIZE=1024 \
  WHITE_LIST_IP=(172.17.0.1)|(192.168.0.25) \
  WHITE_LIST=off

COPY nginx-site.conf /etc/nginx/conf.d/app.conf.template
COPY start-nginx.sh /usr/sbin/start

RUN chmod u+x /usr/sbin/start

EXPOSE 80 443
WORKDIR ${APP_WORKDIR}

CMD [ "start" ]
