
kvm -hda Ubuntu.img \
    -cdrom ubuntu-24.04.3-desktop-amd64.iso \
    -m 8192 \
    -net nic \
    -net user \
#    -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0
#    -soundhw all
