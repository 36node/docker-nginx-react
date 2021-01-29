#!/bin/sh

echo "setting nginx conf ..."
echo "DEBUG": $DEBUG
echo "BUILD": $BUILD
echo "WHITE_LIST": $WHITE_LIST
echo "WHITE_LIST_IP": $WHITE_LIST_IP
echo "APP_VERSION": $APP_VERSION
echo "APP_WORKDIR": $APP_WORKDIR
echo "APP_BASE_PATH": $APP_BASE_PATH
echo "API_PLACEHOLDER": $API_PLACEHOLDER
echo "API_PLACEHOLDER_1": $API_PLACEHOLDER_1
echo "API_PLACEHOLDER_2": $API_PLACEHOLDER_2
echo "API_PLACEHOLDER_3": $API_PLACEHOLDER_3
echo "API_PLACEHOLDER_4": $API_PLACEHOLDER_4
echo "API_PLACEHOLDER_5": $API_PLACEHOLDER_5
echo "API_GATEWAY": $API_GATEWAY
echo "API_GATEWAY_1": $API_GATEWAY_1
echo "API_GATEWAY_2": $API_GATEWAY_2
echo "API_GATEWAY_3": $API_GATEWAY_3
echo "API_GATEWAY_4": $API_GATEWAY_4
echo "API_GATEWAY_5": $API_GATEWAY_5
echo "CLIENT_BODY_TIMEOUT": $CLIENT_BODY_TIMEOUT
echo "CLIENT_HEADER_TIMEOUT": $CLIENT_HEADER_TIMEOUT
echo "CLIENT_MAX_BODY_SIZE": $CLIENT_MAX_BODY_SIZE

## Replace env for nginx conf
envsubst '$DEBUG $BUILD $WHITE_LIST $WHITE_LIST_IP $APP_VERSION $APP_WORKDIR $APP_BASE_PATH $API_PLACEHOLDER $API_GATEWAY $API_PLACEHOLDER_1 $API_GATEWAY_1 $API_PLACEHOLDER_2 $API_GATEWAY_2 $API_PLACEHOLDER_3 $API_GATEWAY_3 $API_PLACEHOLDER_4 $API_GATEWAY_4 $API_PLACEHOLDER_5 $API_GATEWAY_5 $CLIENT_BODY_TIMEOUT $CLIENT_HEADER_TIMEOUT $CLIENT_MAX_BODY_SIZE' < /etc/nginx/conf.d/app.conf.template > /etc/nginx/conf.d/default.conf

## Delete white list config if white list feature off 
if [ ${WHITE_LIST} = 'off' ]; then
    # delete white list config
    sed -i '/^[ ]*\#[ ]*BEGIN_CONFIG_WHEN_WHITE_LIST_ON/,/^[ ]*\#[ ]*END_CONFIG_WHEN_WHITE_LIST_ON/{d;};' /etc/nginx/conf.d/default.conf
fi

## Subset env
export SUBS=$(echo $(env | cut -d= -f1 | sed -e 's/^/\$/'))
echo "inject environments ..."
echo $SUBS
for f in `find "$APP_WORKDIR" -regex ".*\.\(js\|css\|html\|json\|map\)"`; do envsubst "$SUBS" < $f > $f.tmp; mv $f.tmp $f; done

## Start nginx
echo "start nginx"
nginx -g 'daemon off;'
exec "$@"
