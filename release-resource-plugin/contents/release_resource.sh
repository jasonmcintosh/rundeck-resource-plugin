#!/bin/bash
RD_CONFIG_PATH=$1

MAX_VALUE=`/usr/local/bin/consul kv get resources/$RD_CONFIG_PATH/limit`
/usr/local/bin/consul lock -n $MAX_VALUE resources/$RD_CONFIG_PATH "
export CURRENT_VALUE=\"`/usr/local/bin/consul kv get resources/$RD_CONFIG_PATH/used`\"
((CURRENT_VALUE--))
if [[ \$CURRENT_VALUE -lt 0 ]]; then
  echo \"Already released all available resources on $RD_CONFIG_PATH\"
  exit \$CURRENT_VALUE
fi
echo "Current \$CURRENT_VALUE"
/usr/local/bin/consul kv put resources/$RD_CONFIG_PATH/used \$CURRENT_VALUE
"
