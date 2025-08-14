#  = "USER INPUT"

apt-get install -y -v qemu-system

#VM Installation Location
read -p 'Where would you like the VM Image to be stored (default /opt/images/): ' -e -i '/opt/images' imagepath
printf "You have chosen $imagepath
"
mkdir -p $imagepath

#Choose which ISO from the list.

PS3='Please choose the desired OS: '
options=("Ubuntu" "Fedora" "Rocky 9" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Ubuntu")
            wget -nc -P /opt/images/ https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso
            ;;
        "Fedora")
            echo "you chose choice 2"
            ;;
        "Rocky 9")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



wget -nc -P /opt/images/ https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso 


#Name the VM
# vmname = "USER INPUT"
read -p 'Enter the desired name of the VM: ' vmname


#RAM Size
# ram = "USER INPUT"
read -p 'Enter the desired amount of RAM in MB (default 8192): ' -e -i '8192'  ram
printf "Assigning the VM with $ram MB RAM
"

#HDD Size
read -p 'Enter the desired storage size assigned to the VM (Default 16G): ' -e -i '16G'  hddsize
printf "Assigning the VM with a $hddsize storage allocation.
"


qemu-img create -f qcow2 /opt/images/$vmname.img $hddsize

kvm -hda /opt/images/$vmname.img \
    -cdrom /opt/images/ubuntu-24.04.3-desktop-amd64.iso \
    -m $ram \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
