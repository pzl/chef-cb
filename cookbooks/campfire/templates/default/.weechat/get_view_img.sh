#!/bin/bash


cd $1
#notify-send "fetching"
wget -q -nc --no-use-server-timestamps $2 >/dev/null 2>&1
#notify-send "downloaded"
#bug: if nc takes effect (duplicate img) timestamp may not update, so no longer newest
#so ls -t won't get recent img!
ls -t | head -n 1 | sxiv -q -N sxiv-irc -i  &
#notify-send "complete"

#return 0
