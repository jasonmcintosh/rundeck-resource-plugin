#!/bin/bash
RD_CONFIG_PATH=$1
RD_CONFIG_TIMEOUT=$2
if [[ -z "$RD_CONFIG_TIMEOUT" ]]; then
  RD_CONFIG_TIMEOUT="5m"
fi

export MAX_VALUE=`/usr/local/bin/consul kv get resources/$RD_CONFIG_PATH/limit`

acquireLock() {
    export CURRENT_VALUE="`/usr/local/bin/consul lock -n $MAX_VALUE -try \"$RD_CONFIG_TIMEOUT\" resources/$RD_CONFIG_PATH '
    VAL=\`/usr/local/bin/consul kv get resources/$RD_CONFIG_PATH/used\`
    if [[ $VAL -ge $MAX_VALUE ]]; then
      echo "$VAL"
    else
      ((VAL++))
      /usr/local/bin/consul kv put resources/$RD_CONFIG_PATH/used $VAL>/dev/null
      echo "0"
    fi
    '`"
}

acquireLock

while [[ $CURRENT_VALUE -ge $MAX_VALUE ]]; do
  echo "Current value $CURRENT_VALUE at limit of available resources $MAX_VALUE"
  /bin/sleep 5
  acquireLock
done
