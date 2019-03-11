#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}
GRP=rtorrent
USR=rtorrent

# update uids and gids
groupadd -g $RT_GID rtorrent
if [ $? != 0 ]; then
	addgroup -g $RT_GID rtorrent
	if [ $? != 0 ]; then
		GRP=`getent group ${RT_GID} | awk -F: '{print $1}'`
	fi
fi
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent
if [ $? != 0 ]; then
	adduser -u $RT_UID -G $GRP -h /home/rtorrent -D -s /bin/ash rtorrent
	if [ $? != 0 ]; then
        USR=`id -u rtorrent`
    fi
fi

# arrange dirs and configs
mkdir -p /downloads/.rtorrent/session
mkdir -p /downloads/watch
mkdir -p /downloads/.log/rtorrent
if [ ! -e /downloads/.rtorrent/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /downloads/.rtorrent/
fi
set -i "s/{user_name}/$RT_INIT_USER_NAME/" /downloads/.rtorrent/.rtorrent.rc
ln -s /downloads/.rtorrent/.rtorrent.rc /home/rtorrent/
chown -R $USR:$GRP /downloads/.rtorrent
chown -R $USR:$GRP /home/rtorrent
chown $USR:$GRP /downloads/.log/rtorrent

rm -f /downloads/.rtorrent/session/rtorrent.lock

# run
su -l -c "TERM=xterm rtorrent" $USR
