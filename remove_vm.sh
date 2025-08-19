#!/bin/bash


echo -e "\e[36m=====================================\e[0m"
echo -e "\e[1m\e[34m        VM Deletion Script        \e[0m"
echo -e "\e[36m=====================================\e[0m"

#VM Installation Location
read -p 'Where are the VMs installed?  (default /opt/VM/Images): ' -e -i '/opt/VM/Images/' imagepath


#Choose which VM from the list, or all.
