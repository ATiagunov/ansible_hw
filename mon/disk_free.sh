#!/bin/bash

RC=0
if ! command -v telnet &> /dev/null; then
	echo 'telnet: command not found' > /dev/stderr
	RC=1
else
STATUS_COLOR=green
OUTPUT="<html><body><table align="center" cellspacing="15">
  <tr><th>Filesystem</th><th>Usage</th><th>Mounted on</th><th>Color</th></tr>"

DF=$(df -h -x tmpfs -x devtmpfs -x overlay | sed 1d)
DF_AR=(${DF})
for ((fs_i = 0, usage_i = 4, mnt_i = 5; fs_i < ${#DF_AR[@]}; fs_i += 6, usage_i += 6, mnt_i += 6)); do
    COLOR=green
    USAGE=$(echo ${DF_AR[usage_i]} | head -c -2 )
    if [ $USAGE -ge 90 ];then
        COLOR=red
        STATUS_COLOR=red
    fi
    OUTPUT="${OUTPUT}<tr><td>${DF_AR[fs_i]}</td><td>${DF_AR[usage_i]}</td><td>${DF_AR[mnt_i]}</td><td>"\&$COLOR"</td></tr>
    "
done
OUTPUT="${OUTPUT}</table></body></html>"
MSG="status user18.`hostname`_df $STATUS_COLOR `TZ=UTC date +"%a %b %e %H:%M:%S %Z %Y"` - Disk usage
$OUTPUT"

( echo "$MSG"; sleep 1 ) | telnet 192.168.200.3 1984 2>&1 >/dev/null | grep -v "closed by foreign host"

fi

exit $RC
