#!/bin/bash

echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        Start VM Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "Installing QEMU System and KVM..."
apt-get install -q -y qemu-system

#Set VM Installation Location
read -p 'Where are your VM images stored? (default /opt/VM/Images/): ' -e -i '/opt/VM/Images' imagepath
echo -e "Checking $imagepath
"

#Choose which image to boot.

#============================================
#CHOOSE IMAGE TO BOOT, ASK IF THEY WANT TO ATTACH ISO
#============================================
#ls $imagepath/*.img
#ls -a | grep -e *.img

if [ ! -f $imagepath/*.img ]; then
    echo "Image not found! Please create a VM first using create_vm.sh
    "
    exit 1
else
    echo "Available VM Images:"
fi

select image in $imagepath/*.img ; do printf "You have chosen $image"; $image; done

chmod 744 $imagepath/Images/$image.img

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"

/opt/VM/Images# qemu-system-x86_64 -enable-kvm -m $ram -drive file=$image,format=qcow2,if=virtio -display sdl -cdrom $iso