#!/bin/bash
echo -e "\e[1m\e[34m=====================================\e[0m"
echo -e "\e[1m\e[34m        VB-VM Creation Script        \e[0m"
echo -e "\e[1m\e[34m=====================================\e[0m"

############### Default Variables
vb_path="/opt/vm/virtualbox/"
default_country="GB"
default_timezone="Europe/London"
default_locale="en_GB"
###############


# Actual Script
mkdir -p $vb_path/iso
chmod -R 700 /opt/vm/

PS3='Please choose the desired OS: (UI=Unattended Install Compatible)
'
options=("Ubuntu(UI)" "Fedora(UI)" "Rocky10(UI)" "ArchLinux" "WindowsServer2022" "Bazzite" "LinuxMint" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu(UI)")
            echo -e "Downloading\e[1m\e[34m Ubuntu Server 25.04 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso https://mirror.server.net/ubuntu-releases/25.04/ubuntu-25.04-live-server-amd64.iso
            oschosen="Ubuntu"
            os_type="Ubuntu_64"
            iso="$vb_path/iso/ubuntu-25.04-live-server-amd64.iso"
            break
            ;;
        "Fedora(UI)")
            echo -e "Downloading\e[1m\e[34m Fedora Server 43 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-dvd-x86_64-43-1.6.iso
            oschosen="Fedora"
            os_type="Fedora_64"
            iso="$vb_path/iso/Fedora-Server-dvd-x86_64-43-1.6.iso"
            break
            ;;
        "Rocky10(UI)")
            echo -e "Downloading\e[1m\e[34m Rocky Linux 10.1 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://download.rockylinux.org/pub/rocky/10/isos/x86_64/Rocky-10.1-x86_64-dvd1.iso
            oschosen="Rocky_10"
            os_type="RedHat_64"
            iso=$vb_path/iso/Rocky-10.1-x86_64-dvd1.iso
            break
            ;;
        "ArchLinux")
            echo -e "Downloading\e[1m\e[34m Arch Linux 2025.10.01 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://mirror.ipb.de/archlinux/iso/2025.10.01/archlinux-2025.10.01-x86_64.iso
            oschosen="ArchLinux"
            os_type="ArchLinux_64"
            iso="$vb_path/iso/archlinux-2025.10.01-x86_64.iso"
            break
            ;;
        "WindowsServer2022")
            echo -e "Downloading\e[1m\e[34m Windows Server 2022 ISO\e[0m if needed...
            "
            wget -nc -nv --show-progress --progress=bar -P $vb_path/iso/ https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso
            oschosen="Windows_Server_2022"
            os_type="WindowsNT_64"
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
            os_type="Linux_64"
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

#### CPUs
read -p 'How many CPUs should be assigned to the VM? (default 2): ' -e -i '2'  cpus
echo -e "\e[1m\e[34mAssigning the VM with $cpus CPUS. \e[0m
"

#### RAM Size
read -p 'Enter the desired amount of RAM in MB (default 4096): ' -e -i '4096'  memory
echo -e "\e[1m\e[34mAssigning the VM with $memory MB RAM. \e[0m
"

#### HDD Size
read -p 'Enter the desired storage size assigned to the VM in MB (Default 25600): ' -e -i '25600'  hddsize
echo -e "\e[1m\e[34mCreating the VM with a $hddsize storage allocation. \e[0m
"

#### NIC
read -p 'What MAC address should the VM use? (Default auto): ' -e -i 'auto'  mac_addr
echo -e "\e[1m\e[34mAssigning the VM with $mac_addr MAC address. \e[0m
"

# Get available network interfaces
interfaces=($(ip link show | grep -E '^[0-9]+:' | awk -F: '{print $2}' | tr -d ' '))

# Create selection menu
PS3='Please choose a NIC: '
echo "Available network interfaces:"
select interface in "${interfaces[@]}"; do
    if [[ -n "$interface" ]]; then
        echo "You selected: $interface"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Use the selected interface
echo -e "\e[1m\e[34mYou have chosen to attach $interface as the bridge. \e[0m
"

vm_path="$vb_path/$vmname"
mkdir -p $vm_path

VBoxManage createvm --name "$vmname" --ostype "$os_type" --basefolder $vm_path --register
VBoxManage modifyvm "$vmname" --cpus $cpus --memory $memory --nic1 bridged --bridgeadapter1 "$interface" --macaddress1 $mac_addr
VBoxManage createhd --filename "$vm_path/$vmname.vdi" --size $hddsize --format VDI
VBoxManage storagectl "$vmname" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$vmname" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vm_path/$vmname.vdi"
VBoxManage storageattach "$vmname" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$iso"


PS3='Please choose a display mode: (GUI, Seperate, Headless) '
echo -e "Which display mode would you like to run the VM In? \e[0m
"
select dis in "GUI" "Seperate" "Headless";
do
  case $dis in 
    "GUI" )
        dis="gui"
        break
        ;;
    "Separate" )
        dis="separate"
        break
        ;;
    "Headless" )
        dis="headless"
        break
        ;;
    *)
        echo -e "\033[0;31m Invalid Option $REPLY\033[0m"
        echo "Please choose 1 for a Simple VM Window, 2 for a VM Window with options, or 3 to be a headless VM."
        ;;
  esac
done

#### Unattended Install
PS3='Unattended Install? '
echo -e "Do you want to do an unattended install? (Only available for )"
select isoyn in "Yes" "No";
do
    case $isoyn in 
        "Yes" )
            read -p 'What Username would you like set up?: (default Ansible) ' -e -i 'Ansible'  username
            echo -e "\e[1m\e[34mCreating the user $username. \e[0m
            "
            read -s -p "Enter the password to use for $username: " password
            echo -e "\e[1m\e[34mPassword Set. \e[0m
            "
            read -p "Enter the Hostname for the VM: " -e -i $vmname  hostname
            echo -e "\e[1m\e[34mHostname Set. \e[0m
            "
            VBoxManage unattended install "$vmname" --iso="$iso" --user="$username" --full-user-name="$username" --password="$password" --hostname="$hostname.local" --image-index=0 --auxiliary-base-path="$vm_path" --start-vm=$dis --country="$default_country" --time-zone="default_timezone" --locale="$default_locale" --no-install-additions >> /dev/null
            break
            ;;
        "No" )
            echo -e "No unattended install."
            VBoxManage startvm "$vmname" --type $dis
            break
            ;;
        *)
            echo -e "\033[0;31mInvalid Option $REPLY\033[0m"
            ;;
    esac
done


#### Closing Statement
echo -e "\e[1m\e[34mDaemonized VM Created. \e[0m
"