#!/bin/bash
MAX_VALUE=`/usr/local/bin/consul kv get resources/$RD_CONFIG_RESOURCEPATH/limit`
/usr/local/bin/consul lock -n $MAX_VALUE resources/$RD_CONFIG_RESOURCEPATH "
export CURRENT_VALUE=\"`/usr/local/bin/consul kv get resources/$RD_CONFIG_RESOURCEPATH/used`\"
((CURRENT_VALUE--))
if [[ \$CURRENT_VALUE -lt 0 ]]; then
  echo \"Already released all available resources on $RD_CONFIG_RESOURCEPATH\"
  exit \$CURRENT_VALUE
fi
echo "Current \$CURRENT_VALUE"
/usr/local/bin/consul kv put resources/$RD_CONFIG_RESOURCEPATH/used \$CURRENT_VALUE
"
