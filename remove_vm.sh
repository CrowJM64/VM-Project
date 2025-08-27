#!/bin/bash


echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Deletion Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

#VM Installation Location
read -p 'Where are the VMs installed?  (default /opt/VM/Images): ' -e -i '/opt/VM/Images/' imagepath


#Choose which VM from the list, or all.

if [ ! -f $imagepath/*.img ]; then
    echo "Image not found! Please create a VM first using create_vm.sh
    "
    exit 1
else
    echo "Available VM Images:"
fi

select image in "$imagepath"/*.img; do
    # Check if the user made a valid selection
    if [[ -z "$image" ]]; then
        echo "Invalid selection. Please choose a number from the list."
        continue
    fi
    break
done

echo -e "You have chosen to DELETE $image."
rm -rf $imagepath/$image

echo -e "$image has been deleted."
