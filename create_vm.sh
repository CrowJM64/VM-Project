#!/bin/bash


echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Creation Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "Installing QEMU System and KVM..."
apt-get install -q -y qemu-system

#VM Installation Location
read -p 'Where would you like the VM Image to be stored (default /opt/VM/): ' -e -i '/opt/VM' imagepath
printf "You have chosen $imagepath, creating directories /ISO and /Images
"
mkdir -p $imagepath $imagepath/ISO $imagepath/Images

#Choose which ISO from the list.

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "Rocky 10" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo -e "Downloading\e[1m\e[34m Ubuntu 24.04.3 ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso
            oschosen="Ubuntu"
            iso="$imagepath/ISO/ubuntu-24.04.3-desktop-amd64.iso"
            break
            ;;
        "Fedora")
            echo -e "Downloading\e[1m\e[34m Fedora 42 ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso
            oschosen="Fedora"
            iso="$imagepath/ISO/Fedora-Workstation-Live-42-1.1.x86_64.iso"
            break
            ;;
        "Rocky 10")
            echo -e "Downloading\e[1m\e[34m Rocky Linux 10 ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky 10"
            iso=$imagepath/ISO/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "Quit")
            echo -e "Exiting VM creation script."
            exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



#Name the VM
read -p 'Enter the desired name of the VM: ' -e -i "$oschosen" vmname
printf "Creating the image: $vmname
"

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"

#HDD Size
read -p 'Enter the desired storage size assigned to the VM (Default 16G): ' -e -i '16G'  hddsize
printf "Assigning the VM with a $hddsize storage allocation.
"

qemu-img create -f qcow2 $imagepath/Images/$vmname.img $hddsize

chmod 744 $imagepath/Images/$vmname.img

kvm -hda $imagepath/Images/$vmname.img \
    -cdrom $iso \
    -m $ram \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all