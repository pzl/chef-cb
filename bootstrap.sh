#!/bin/bash

COOKBOOKS_ALL=$(ls -1 cookbooks)
PERM_USER=$(logname) #or use $SUDO_USER

echo -n "User to own installed files (skip for current user)[$PERM_USER]: "
read u

if [ "$u" != "" ]; then
	if id -u "$1" >/dev/null 2>&1; then
		PERM_USER=$u
	else
		echo "User $u does not exist"
		exit 1
	fi
fi

INST_DIR=$(getent passwd $PERM_USER | cut -d: -f6 )

echo -n "Directory to install to [$INST_DIR]: "
read h

if [ "$h" != "" ]; then
	if [ -d "$h" ]; then
		INST_DIR=$h
	else
		echo "Directory $h does not exist"
		exit 1
	fi
fi

echo -n "Installation: ([T]iny, [F]ull, [D]efault) [D]: "
read i

case "$i" in
	t|T)
		INST=$(echo -e "chrome\nconky\ncrunch\ngit\nsublime\nterminus\ntheme\nvim");;
	f|F)
		INST=$COOKBOOKS_ALL;;
	m|M) #manual
		INST="";;
	*|d|D)
		INST=$(echo "$COOKBOOKS_ALL" | sed -E '/(calibre|avr|gifsicle|kicad|lamp|latex|mojo|mongo|ncdu|nginx|saleae|sensors|vagrant|wireshark)/d');;
esac

cat <<EOH > node.json
{
	"user": {
		"name": "$PERM_USER",
		"home": "$INST_DIR"
	},
	"run_list": [
EOH
COOKBOOKS_MOST=$(echo "$INST" | head -n -1)
COOKBOOKS_LAST=$(echo "$INST" | tail -n 1)

for line in $COOKBOOKS_MOST; do
	echo -e "        \"recipe[$line]\"," >> node.json
done
echo -e "        \"recipe[$COOKBOOKS_LAST]\"" >> node.json
cat <<EOH >> node.json
	]
}
EOH

sudo apt-get update
sudo apt-get -y upgrade

#Installs chef
curl -L https://www.opscode.com/chef/install.sh | sudo bash

#runs chef solo
sudo chef-solo -c solo.rb -j node.json