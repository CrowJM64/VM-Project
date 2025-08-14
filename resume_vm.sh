#!/bin/bash


echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        Start VM Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "Installing QEMU System and KVM..."
apt-get install -q -y qemu-system

#VM Installation Location
read -p 'Where are your VM images stored? (default /opt/VM/Images/): ' -e -i '/opt/VM/Images' imagepath

printf "Opening $imagepath
"
cd $imagepath

#Choose which image to boot.


ls -a | grep -e *.img

break



#============================================

select image in $imagepath
do
    case $opt in
        "Ubuntu")
            echo -e "Downloading \e[1m\e[34m Ubuntu 24.04.3 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso
            oschosen="Ubuntu"
            iso="$imagepath/ubuntu-24.04.3-desktop-amd64.iso"
            break
            ;;
        "Fedora")
            echo -e "Downloading \e[1m\e[34m Fedora 42 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso
            oschosen="Fedora"
            iso="$imagepath/Fedora-Workstation-Live-42-1.1.x86_64.iso"
            break
            ;;
        "Rocky 10")
            echo -e "Downloading \e[1m\e[34m Rocky Linux 10 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky 10"
            iso=$imagepath/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "Quit")
            break
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


qemu-img create -f qcow2 $imagepath$vmname.img $hddsize

kvm -hda $imagepath$vmname.img \
    -cdrom $iso \
    -m $ram \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m       Start VM       \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "Installing QEMU System and KVM..."
apt-get install -q -y qemu-system

#VM Installation Location
read -p 'Where would you like the VM Image to be stored (default /opt/VM/): ' -e -i '/opt/VM' imagepath
printf "You have chosen $imagepath
"
mkdir -p $imagepath

#Choose which ISO from the list.

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "Rocky 10" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo -e "Downloading \e[1m\e[34m Ubuntu 24.04.3 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso
            oschosen="Ubuntu"
            iso="$imagepath/ubuntu-24.04.3-desktop-amd64.iso"
            break
            ;;
        "Fedora")
            echo -e "Downloading \e[1m\e[34m Fedora 42 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso
            oschosen="Fedora"
            iso="$imagepath/Fedora-Workstation-Live-42-1.1.x86_64.iso"
            break
            ;;
        "Rocky 10")
            echo -e "Downloading \e[1m\e[34m Rocky Linux 10 ISO...\e[0m"
            wget -nc -nv --show-progress --progress=bar -P $imagepath https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky 10"
            iso=$imagepath/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "Quit")
            break
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


qemu-img create -f qcow2 $imagepath$vmname.img $hddsize

kvm -hda $imagepath$vmname.img \
    -cdrom $iso \
    -m $ram \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
