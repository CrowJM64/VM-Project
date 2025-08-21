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

if [ ! -f $imagepath/*.img ]; then
    echo "Image not found! Please create a VM first using create_vm.sh
    "
    exit 1
else
    echo "Available VM Images:"
fi

select image in "$imagepath"/*.img; do
    # Check if the user made a valid selection
    if [[ -z "$image" ]]; then
        echo "Invalid selection. Please choose a number from the list."
        continue
    fi
    break
done

printf "You have chosen: %s\n" "$image"

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"

qemu-system-x86_64 -enable-kvm -m $ram -drive file=$image,format=qcow2,if=virtio -display sdl