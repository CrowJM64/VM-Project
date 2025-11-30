#!/bin/bash
echo -e "\e[1m\e[34m=====================================\e[0m"
echo -e "\e[1m\e[34m        VB-VM Creation Script        \e[0m"
echo -e "\e[1m\e[34m=====================================\e[0m"

############### Default Variables
vb_path="/opt/vm/virtualbox/"

###############


# Actual Script
mkdir -p $vb_path/iso
chmod -R 700 /opt/vm/

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "ArchLinux" "Rocky10" "WindowsServer2022" "Bazzite" "LinuxMint" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo -e "Downloading\e[1m\e[34m Ubuntu 25.04 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso https://mirror.server.net/ubuntu-releases/25.04/ubuntu-25.04-desktop-amd64.iso
            oschosen="Ubuntu"
            iso="$vb_path/iso/ubuntu-25.04-desktop-amd64.iso"
            break
            ;;
        "Fedora")
            echo -e "Downloading\e[1m\e[34m Fedora 42 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso
            oschosen="Fedora"
            iso="$vb_path/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso"
            break
            ;;
        "ArchLinux")
            echo -e "Downloading\e[1m\e[34m Arch Linux 2025.10.01 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://mirror.ipb.de/archlinux/iso/2025.10.01/archlinux-2025.10.01-x86_64.iso
            oschosen="ArchLinux"
            iso="$vb_path/iso/archlinux-2025.10.01-x86_64.iso"
            break
            ;;
        "Rocky10")
            echo -e "Downloading\e[1m\e[34m Rocky Linux 10 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky_10"
            iso=$vb_path/iso/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "WindowsServer2022")
            echo -e "Downloading\e[1m\e[34m Windows Server 2022 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso
            oschosen="Windows_Server_2022"
            iso=$vb_path/iso/SERVER_EVAL_x64FRE_en-us.iso
            break
            ;;
        "Bazzite")
            echo -e "Downloading\e[1m\e[34m Bazzite ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://download.bazzite.gg/bazzite-deck-nvidia-stable-amd64.iso
            oschosen="Bazzite"
            iso=$vb_path/iso/bazzite-deck-nvidia-stable-amd64.iso
            break
            ;;
        "LinuxMint")
            echo -e "Downloading\e[1m\e[34m Linux Mint ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://pub.linuxmint.io/stable/22.1/linuxmint-22.1-cinnamon-64bit.iso
            oschosen="LinuxMint"
            iso=$vb_path/iso/linuxmint-22.1-cinnamon-64bit.iso
            break
            ;;
        "Quit")
            echo -e "Exiting VM creation script."
            exit 1
            ;;
        *)
            echo -e "\033[0;31m Invalid Option $REPLY\033[0m"
            ;;
    esac
done


#### Name the VM
read -p 'Enter the desired name of the VM: ' -e -i "$oschosen" vmname
echo -e "\e[1m\e[34mCreating the image: $vmname \e[0m
"

#### RAM Size
read -p 'Enter the desired amount of RAM in MB (default 4096): ' -e -i '4096'  memory
echo -e "\e[1m\e[34mAssigning the VM with $memory MB RAM \e[0m
"

#### HDD Size
read -p 'Enter the desired storage size assigned to the VM (Default 25G): ' -e -i '25G'  hddsize
echo -e "\e[1m\e[34mCreating the VM with a $hddsize storage allocation. \e[0m
"

VBoxManage createvm --name "$vmname" --ostype "OS_Type" --basefolder $path --register
VBoxManage modifyvm "$vmname" --cpus $cpus --memory $memory --nic1 bridged --macaddress1 
VBoxManage createhd --filename "$vmname.vdi" --size $hddsize --format $hddform
VBoxManage storagectl "$vmname" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$vmname" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vmname.vdi"

VBoxHeadless --startvm "$vmname"


#VBoxManage createvm --name "TestDebian" --ostype "Debian_64" --register
#VBoxManage modifyvm "TestDebian" --memory 1024 --nic1 nat
#VBoxManage createhd --filename "TestDebian.vdi" --size 80000 --format VDI
#VBoxManage storagectl "TestDebian" --name "SATA Controller" --add sata --controller IntelAhci
#VBoxManage storageattach "TestDebian" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "TestDebian.vdi"
#VBoxHeadless --startvm "TestDebian"

#### Closing Statement
echo -e "\e[1m\e[34mDaemonized VM Created. \e[0m
"