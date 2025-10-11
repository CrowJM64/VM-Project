#!/bin/bash
echo off
echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Resumption Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "\e[1m\e[34mChecking QEMU System is installed... \e[0m"
apt-get install -qq -y qemu-system

#### Choose VM Image Location
read -p 'Where are your VM images stored? (default /opt/vm/images/): ' -e -i '/opt/vm/images' imagepath
echo -e "Checking $imagepath
"

#### Check if there are IMG files in the designated path.
if [ ! -f $imagepath/*.img ]; then
    echo -e "\033[0;31mImage not found! Please create a VM first using create_vm.sh!\033[0m
    "
    exit 1
else
    echo "Available VM Images:"
fi

#### Choose Image from available IMG files.
select image in "$imagepath"/*.img; do
    # Check if the user made a valid selection
    if [[ -z "$image" ]]; then
        echo -e "\033[0;31mInvalid selection. Please choose an option from the list.\033[0m"
        continue
    fi
    break
done

echo -e "\e[1m\e[34mYou have chosen $image. \e[0m"

#### ISO Choices
echo -e "Do you want to attach an ISO?"
select isoyn in "Yes" "No";
do
    case $isoyn in 
        "Yes" )
            read -p 'Where is the ISO stored? (default /opt/vm/iso/): ' -e -i '/opt/vm/iso' isopath
            echo -e "Checking $isopath"
            $isoyn = yes
            if [ ! -f $isopath/*.iso ]; then
                echo "ISO not found! Please check ISO filepath."
            else
                echo "Available ISO Images:"
                select iso in "$isopath"/*.iso; do
                    # Check if the user made a valid selection
                    if [[ -z "$iso" ]]; then
                        echo "Invalid selection. Please choose an option from the list."
                        continue
                    fi
                    break
                done
            fi
            break
            ;;
        "No" )
            echo -e "No ISO being added."
            break
            ;;
        *)
            echo -e "\033[0;31mInvalid Option $REPLY\033[0m"
            ;;
    esac
done

#### Display Choices

echo -e "Which display mode would you like to run the VM In? \e[0m
"
select dis in "SDL - Simple Window" "GTK - Window With Options" "Headless";
do
  case $dis in 
    "SDL - Simple Window" )
        dis="sdl"
        break
        ;;
    "GTK - Window With Options" )
        dis="gtk"
        break
        ;;
    "Headless" )
        dis="none"
        break
        ;;
    *)
        echo -e "\033[0;31m Invalid Option $REPLY\033[0m"
        echo "Please choose 1 for a Simple VM Window, 2 for a VM Window with options, or 3 to be a headless VM."
        ;;
  esac
done

#### RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
echo -e "\e[1m\e[34mAssigning the VM with $ram MB RAM \e[0m
"

#### Assign Ports to forward to VM from LOCALHOST
read -p 'Assign the ports on Localhost to forward to the VM: 
e.g. hostfwd=tcp::2200-:22,hostfwd=tcp::8888-:8080
' -e -i "hostfwd=tcp::2200-:22" hostfwd

if [[ $isoyn == "yes" ]]; then
    qemu-system-x86_64 -enable-kvm -cpu host -m $ram -drive file="$image",format=qcow2,if=virtio -display $dis -daemonize -cdrom $iso -netdev user,id=net0,$hostfwd -device virtio-net-pci,netdev=net0
else
    qemu-system-x86_64 -enable-kvm -cpu host -m $ram -drive file="$image",format=qcow2,if=virtio -display $dis -daemonize -netdev user,id=net0,$hostfwd -device virtio-net-pci,netdev=net0
fi