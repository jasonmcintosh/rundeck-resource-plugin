#!/bin/bash
if [[ -z "$RD_CONFIG_TIMEOUT" ]]; then
  RD_CONFIG_TIMEOUT="5m"
fi

echo "Aquiring lock for path $RD_CONFIG_RESOURCEPATH with a timeout of $RD_CONFIG_TIMEOUT"
export MAX_VALUE=`/usr/local/bin/consul kv get resources/$RD_CONFIG_RESOURCEPATH/limit`
echo "Maximum value of concurrent processes is $MAX_VALUE"

acquireLock() {
    export CURRENT_VALUE="`/usr/local/bin/consul lock -n $MAX_VALUE -try \"$RD_CONFIG_TIMEOUT\" resources/$RD_CONFIG_RESOURCEPATH '
    VAL=\`/usr/local/bin/consul kv get resources/$RD_CONFIG_RESOURCEPATH/used\`
    if [[ $VAL -ge $MAX_VALUE ]]; then
      echo "$VAL"
    else
      echo "$VAL"
      ((VAL++))
      /usr/local/bin/consul kv put resources/$RD_CONFIG_RESOURCEPATH/used $VAL>/dev/null
    fi
    '`"
}

acquireLock
echo "Current value $CURRENT_VALUE at limit of available resources $MAX_VALUE"

while [[ $CURRENT_VALUE -ge $MAX_VALUE ]]; do
  echo " - Current value is beyond allowed value, sleeping and trying again... "
  /bin/sleep 5
  acquireLock
  echo " - Current value $CURRENT_VALUE at limit of available resources $MAX_VALUE"
done
