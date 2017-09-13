#!/bin/bash
if [ -z $1 ]; then
    echo "usage $0 binaryname"
    exit 1
fi

_pwd=`/bin/pwd`
fullpath=$_pwd/$1

tmp=`ls $fullpath`

if [ $? -ne 0 ]; then
    exit 1
fi

echo "service $1
{
    flage = REUSE
    socket_type = stream
    wait = no
    user = root
    server = $fullpath
    disable = no
}" > "/etc/xinetd.d/$1"

if [ $? -eq 1 ]; then
    exit 1
fi

cat /etc/services | sed '$d' > /etc/services
echo "$1        9999/tcp" >> "/etc/services"

service xinetd restart

echo "Done!!"
