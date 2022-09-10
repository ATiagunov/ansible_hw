#!/bin/bash

STATUS_COLOR=green

OUTPUT="<html><body><table align="center" cellspacing="15">
  <tr><th>User</th><th>Count</th><th>Color</th></tr>"

PS=$(ps -eo user= | sort | uniq -c)
PS_AR=(${PS})
	for ((count_i = 0, user_i = 1; count_i < ${#PS_AR[@]}; count_i += 2, user_i += 2)); do
	    COLOR=green

	    if [ ${PS_AR[count_i]} -gt 10 ];then
		    COLOR=red
		    STATUS_COLOR=red
	    fi
	    OUTPUT="${OUTPUT}<tr><td>${PS_AR[user_i]}</td><td>${PS_AR[count_i]}</td><td>"\&$COLOR"</td></tr>"
done
OUTPUT="${OUTPUT}</table></body></html>"

MSG="status shift.user18 $STATUS_COLOR `TZ=UTC date +"%a %b %e %H:%M:%S %Z %Y"` - Processes per user
$OUTPUT"

( echo "$MSG"; sleep 1 ) | telnet 192.168.200.3 1984 2>&1 >/dev/null | grep -v "closed by foreign host"

exit 0
