#!/bin/sh

# Create the boot script
echo "echo 'Hello from my boot script!'" > /etc/init.d/my_boot_script.sh
chmod +x /etc/init.d/my_boot_script.sh

# Add the script to run on boot
echo "/etc/init.d/my_boot_script.sh" >> /etc/local.d/my_boot_script.start

# Reboot the system to execute the script
reboot

# Delete this script
rm -- "$0"
