#!/bin/bash

echo -e "\e[1m\e[34m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Creation Script        \e[0m"
echo -e "\e[1m\e[34m=====================================\e[0m"

echo -e "This script will install qemu-system (For VM Emulation) if not already installed. Do you consent?"
select consent in "Yes" "No";
do
    case $consent in 
        "Yes" )
            echo -e "\e[1m\e[34mChecking QEMU System is installed... \e[0m"
            apt-get install -qq -y qemu-system
            break
            ;;
        "No" )
            echo -e "\033[0;31mExiting VM Creation Script.\033[0m"
            exit 1
            ;;
        *)
            echo -e "\033[0;31mInvalid Option $REPLY\033[0m"
            ;;
    esac
done

#### VM Installation Location
read -p 'Where would you like the VM Image to be stored (default /opt/vm): ' -e -i '/opt/vm' imagepath
echo -e "\e[1m\e[34mYou have chosen $imagepath, creating directories /iso and /images \e[0m
"
mkdir -p $imagepath $imagepath/iso $imagepath/images

#### Choose which ISO from the list.

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "ArchLinux" "Rocky10" "WindowsServer2022" "Bazzite" "LinuxMint" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            echo -e "Downloading\e[1m\e[34m Ubuntu 25.04 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso https://mirror.server.net/ubuntu-releases/25.04/ubuntu-25.04-desktop-amd64.iso
            oschosen="Ubuntu"
            iso="$imagepath/iso/ubuntu-25.04-desktop-amd64.iso"
            break
            ;;
        "Fedora")
            echo -e "Downloading\e[1m\e[34m Fedora 42 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://download.fedoraproject.org/pub/fedora/linux/releases/42/Workstation/x86_64/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso
            oschosen="Fedora"
            iso="$imagepath/iso/Fedora-Workstation-Live-42-1.1.x86_64.iso"
            break
            ;;
        "ArchLinux")
            echo -e "Downloading\e[1m\e[34m Arch Linux 2025.10.01 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://mirror.ipb.de/archlinux/iso/2025.10.01/archlinux-2025.10.01-x86_64.iso
            oschosen="ArchLinux"
            iso="$imagepath/iso/archlinux-2025.10.01-x86_64.iso"
            break
            ;;
        "Rocky10")
            echo -e "Downloading\e[1m\e[34m Rocky Linux 10 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.0-x86_64-dvd1.iso
            oschosen="Rocky_10"
            iso=$imagepath/iso/Rocky-10.0-x86_64-dvd1.iso
            break
            ;;
        "WindowsServer2022")
            echo -e "Downloading\e[1m\e[34m Windows Server 2022 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso
            oschosen="Windows_Server_2022"
            iso=$imagepath/iso/SERVER_EVAL_x64FRE_en-us.iso
            break
            ;;
        "Bazzite")
            echo -e "Downloading\e[1m\e[34m Bazzite ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://download.bazzite.gg/bazzite-deck-nvidia-stable-amd64.iso
            oschosen="Bazzite"
            iso=$imagepath/iso/bazzite-deck-nvidia-stable-amd64.iso
            break
            ;;
        "LinuxMint")
            echo -e "Downloading\e[1m\e[34m Linux Mint ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $imagepath/iso/ https://pub.linuxmint.io/stable/22.1/linuxmint-22.1-cinnamon-64bit.iso
            oschosen="LinuxMint"
            iso=$imagepath/iso/linuxmint-22.1-cinnamon-64bit.iso
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
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
echo -e "\e[1m\e[34mAssigning the VM with $ram MB RAM \e[0m
"

#### HDD Size
read -p 'Enter the desired storage size assigned to the VM (Default 25G): ' -e -i '25G'  hddsize
echo -e "\e[1m\e[34mCreating the VM with a $hddsize storage allocation. \e[0m
"

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

#### Creating Image
qemu-img create -f qcow2 "$imagepath/images/$vmname.img" $hddsize

#### Set permissions RWX to Owner, none to others.
chmod 700 "$imagepath/images/$vmname.img"

#### Assign Ports to forward to VM from LOCALHOST
read -p 'Assign the ports on Localhost to forward to the VM: 
e.g. hostfwd=tcp::2200-:22,hostfwd=tcp::8888-:8080
' -e -i "hostfwd=tcp::2200-:22" hostfwd

#### Actual VM Run command
qemu-system-x86_64 -enable-kvm -cpu host -m $ram -hda "$imagepath/images/$vmname.img" -cdrom $iso -display $dis -daemonize -netdev user,id=net0,$hostfwd -device virtio-net-pci,netdev=net0

#### Closing Statement
echo -e "\e[1m\e[34mDaemonized VM Created. Closing the QEMU image stops the VM. \e[0m
"
echo -e "\e[1m\e[34mTo re-open a VM, use the resume_vm script. \e[0m
"


#qemu-system-x86_64 -enable-kvm -cpu host -m $ram -hda "$imagepath/images/$vmname.img" -cdrom $iso -display $dis -daemonize -netdev user,id=net0,hostfwd=tcp::2200-:22 -device virtio-net-pci,netdev=net0