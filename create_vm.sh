#!/bin/bash

echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Creation Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

echo -e "Checking QEMU System and Bridge Utils are installed..."
apt-get install -qq -y qemu-system
apt-get install -qq -y bridge-utils

#VM Installation Location
read -p 'Where would you like the VM Image to be stored (default /opt/VM/): ' -e -i '/opt/VM' imagepath
echo -e "\e[1m\e[34mYou have chosen $imagepath, creating directories /ISO and /Images \e[0m
"
mkdir -p $imagepath $imagepath/ISO $imagepath/Images

#Choose which ISO from the list.

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "Rocky10" "WindowsServer2022" "Bazzite" "LinuxMint" "Quit")
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
        "Rocky10")
            echo -e "Downloading\e[1m\e[34m Rocky Linux 10 ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky 10"
            iso=$imagepath/ISO/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "WindowsServer2022")
            echo -e "Downloading\e[1m\e[34m Windows Server 2022 ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso
            oschosen="Windows_Server_2022"
            iso=$imagepath/ISO/SERVER_EVAL_x64FRE_en-us.iso
            break
            ;;
        "Bazzite")
            echo -e "Downloading\e[1m\e[34m Bazzite ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://download.bazzite.gg/bazzite-deck-nvidia-stable-amd64.iso
            oschosen="Bazzite"
            iso=$imagepath/ISO/bazzite-deck-nvidia-stable-amd64.iso
            break
            ;;
        "LinuxMint")
            echo -e "Downloading\e[1m\e[34m Linux Mint ISO\e[0m if needed..."
            wget -nc -nv --show-progress --progress=bar -P $imagepath/ISO/ https://pub.linuxmint.io/stable/22.1/linuxmint-22.1-cinnamon-64bit.iso
            oschosen="LinuxMint"
            iso=$imagepath/ISO/linuxmint-22.1-cinnamon-64bit.iso
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
echo -e "\e[1m\e[34mCreating the image: $vmname \e[0m
"

#RAM Size
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"
echo -e "\e[1m\e[34mAssigning the VM with $ram MB RAM \e[0m
"

#HDD Size
read -p 'Enter the desired storage size assigned to the VM (Default 20G): ' -e -i '20G'  hddsize
printf "Assigning the VM with a $hddsize storage allocation.
"
echo -e "\e[1m\e[34mAssigning the VM with a $hddsize storage allocation. \e[0m
"

qemu-img create -f qcow2 "$imagepath/Images/$vmname.img" $hddsize

chmod 700 "$imagepath/Images/$vmname.img"

kvm -hda "$imagepath/Images/$vmname.img" \
    -display sdl \
    -cdrom $iso \
    -m $ram \
    -net nic \
    -net user \
    -daemonize \

echo -e "\e[1m\e[34mDaemonized VM Created. Closing the QEMU image stops the VM. \e[0m
"

echo -e "\e[1m\e[34mTo re-open a VM, use the resume_vm script. \e[0m
"
