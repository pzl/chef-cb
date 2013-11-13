#determine arch
wget "http://downloads.saleae.com/Logic%201.1.15%20($ARCH-bit).zip"; unzip "Logic 1.1.15 ($ARCH-bit).zip"; rm -rf "Logic 1.1.15 ($ARCH-bit).zip"; mv "Logic 1.1.15 ($ARCH-bit)" ~/bin/;
sudo cp "~/bin/Logic 1.1.15 ($ARCH-bit)/Drivers/99-SaleaeLogic.rules" /etc/udev/rules.d/;
sudo udevadm control --reload-rules; sudo udevadm trigger;