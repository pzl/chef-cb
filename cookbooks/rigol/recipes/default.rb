#Rigol scope
#todo: target product instead of whole driver
sudo cp "lib/10-Rigol.rules" "/etc/udev/rules.d/"; sudo chown root "/etc/udev/rules.d/10-Rigol.rules"; sudo chmod 644 "/etc/udev/rules.d/10-Rigol.rules";
sudo udevadm control --reload-rules; sudo udevadm trigger;

#add func gen