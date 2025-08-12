
qemu-img create -f qcow2 /opt/images/ubuntu.img 8G

kvm -hda /opt/images/ubuntu.img \
    -cdrom /opt/images/ubuntu-24.04.3-desktop-amd64.iso \
    -m 8192 \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
