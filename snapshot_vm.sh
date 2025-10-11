#!/bin/bash

echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Snapshot Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"


#Set VM  Location
read -p 'Where are your VM images stored? (default /opt/vm/images/): ' -e -i '/opt/vm/images' imagepath
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

read -p 'Where would you like to name the Snapshot?: ' snapname
echo -e "You have chosen $snapname
"

read -p 'Where would you like to save the VM to? (default /opt/vm/snaps/): ' -e -i '/opt/vm/snaps' snappath
echo -e "You have chosen $snappath
"
mkdir -p $snappath

qemu-img convert -f qcow2 -O qcow2 $image2snap $snappath/$snapname.img

echo -e "Would you like to run the VM now?"
select consent in "Yes" "No";
do
    case $consent in 
        "Yes" )
            break
            ;;
        "No" )
            echo -e "\033[0;31mExiting VM Snapshot Script.\033[0m"
            exit 1
            ;;
        *)
            echo -e "\033[0;31mInvalid Option $REPLY\033[0m"
            ;;
    esac
done

#### Display Choices
PS3='Choose which Display Mode you would like to use:'
select dis in "SDL - Simple Window (Reccomended)" "GTK - Window With Options" "Headless";
do
  case $dis in 
    "SDL - Simple Window (Reccomended)" )
        dis="sdl"
        echo -e "\e[1m\e[34mYou have chosen SDL - Simple Window \e[0m"
        break
        ;;
    "GTK - Window With Options" )
        dis="gtk"
        echo -e "\e[1m\e[34mYou have chosen GTK - Window With Options \e[0m"
        break
        ;;
    "Headless" )
        dis="none"
        echo -e "\e[1m\e[34mYou have chosen Headless \e[0m"
        break
        ;;
    *)
        echo -e "\033[0;31m Invalid Option $REPLY\033[0m"
        echo "Please choose 1 for a Simple VM Window, 2 for a VM Window with options, or 3 to be a headless VM."
        ;;
  esac
done

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"
#### Assign Ports to forward to VM from LOCALHOST
read -p 'Assign the ports on Localhost to forward to the VM: 
e.g. hostfwd=tcp::2200-:22,hostfwd=tcp::8888-:8080
' -e -i "hostfwd=tcp::2200-:22" hostfwd

qemu-system-x86_64 -enable-kvm -cpu host -m $ram -drive file="$snappath/$snapname.img",format=qcow2,if=virtio -display $dis -daemonize -netdev user,id=net0,$hostfwd -device virtio-net-pci,netdev=net0