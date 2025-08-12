
mkdir /opt/images/

wget -nc -P /opt/images/ https://mirror.server.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-desktop-amd64.iso 

qemu-img create -f qcow2 /opt/images/ubuntu.img 20G

kvm -hda /opt/images/ubuntu.img \
    -cdrom /opt/images/ubuntu-24.04.3-desktop-amd64.iso \
    -m 8192 \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
