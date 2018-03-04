#!/bin/bash

A=`uname -a | cut -d ' ' -f 3`
printf "The currently running kernel is $A\n\n"
D=`dpkg -l | grep linux | awk 'BEGIN { FS = " " } ; { print  $2 }' | grep ${A:0:5} | grep -v ${A:6:3}`
if [[ -z "${D// }" ]]; then
    printf "No older kernels to purge. Happy $(date +%a)day :) \n"
else
    printf "Purging the following kernels:\n$D\n\n"
    while true; do
        read -p "Do you wish to proceed? " yn
        case $yn in
            [Yy]* ) sudo apt purge -y $D; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
