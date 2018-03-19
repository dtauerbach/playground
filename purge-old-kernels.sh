#!/bin/bash

A=$(uname -a | cut -d ' ' -f 3)
printf "The currently running kernel is $A\n"
VERS="${A:0:5}"
BUILD="${A:6:3}"
printf "version: $VERS\n"
printf "build: $BUILD\n\n"
D=$(dpkg -l | grep linux | awk 'BEGIN { FS = " " } ; { print  $2 }' | grep "$VERS" | grep -v "$BUILD")
F=""
while read -r line; do
    FULL=`echo "$line" | grep -o -P "$VERS.{0,4}"`
    MINOR=${FULL:6:3}
    if [ "$MINOR" -gt "$BUILD" ]
    then
        printf "Ignoring kernel that is newer than current version: $line\n\n"
        continue
    fi
    F+="$line "
done <<< "$D"

if [[ -z "${F// }" ]]; then
    printf "No older kernels to purge. Happy $(date +%a)day :) \n"
else
    printf "Purging the following kernels:\n$F\n\n"
    while true; do
        read -p "Do you wish to proceed? " yn
        case $yn in
            [Yy]* ) sudo apt purge -y $F; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
