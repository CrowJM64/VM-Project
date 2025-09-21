#!/bin/bash

echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Snapshot Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"


#Set VM  Location
read -p 'Where are your VM images stored? (default /opt/VM/Images/): ' -e -i '/opt/VM/Images' imagepath
echo -e "Checking $imagepath
"

#Choose which image to snapshot.
if [ ! -f $imagepath/*.img ]; then
    echo "Image not found! Please create a VM first using create_vm.sh
    "
    exit 1
else
    echo "Available VM Images:"
fi

select image2snap in "$imagepath"/*.img; do
    # Check if the user made a valid selection
    if [[ -z "$image2snap" ]]; then
        echo "Invalid selection. Please choose a number from the list."
        continue
    fi
    break
done

printf "You have chosen: %s\n" "$image2snap"

read -p 'What would you like to name the Snapshot? (default $image2snap): ' -e -i '$image2snap.img' snapname

qemu-img create -f qcow2 -b $image2snap -F qcow2 $snapname

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"

qemu-system-x86_64 -enable-kvm -m $ram -drive file="$image",format=qcow2,if=virtio -display sdl -daemonize


