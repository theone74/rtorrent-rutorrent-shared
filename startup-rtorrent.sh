#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
if [ $? != 0 ]; then
addgroup -g $RT_GID rtorrent
fi
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent
if [ $? != 0 ]; then
adduser -u $RT_UID -G rtorrent -h /home/rtorrent -D -s /bin/ash rtorrent
fi

# arrange dirs and configs
mkdir -p /downloads/.rtorrent/session
mkdir -p /downloads/watch
mkdir -p /downloads/.log/rtorrent
if [ ! -e /downloads/.rtorrent/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /downloads/.rtorrent/
fi
ln -s /downloads/.rtorrent/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /downloads/.rtorrent
chown -R rtorrent:rtorrent /home/rtorrent
chown rtorrent:rtorrent /downloads/.log/rtorrent

rm -f /downloads/.rtorrent/session/rtorrent.lock

# run
su -l -c "TERM=xterm rtorrent" rtorrent

