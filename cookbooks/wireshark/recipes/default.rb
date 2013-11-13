package 'wireshark-common'

sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark dan
sudo chmod +x /usr/bin/dumpcap