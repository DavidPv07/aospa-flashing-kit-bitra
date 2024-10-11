#!/usr/bin/env bash
#
# Flash firmware zip arsalan devuploads.com
# (https://devuploads.com/users/arsalan_zeus/2797/IN) on bitra
#
# Author: Adithya R (@ghostrider_reborn)

function wait_exit() {
    read -p "Press enter to exit..."
    exit $1
}

# Firmware zip must be stored as firmware.zip
if [ ! -f "firmware.zip" ]; then
    echo "Error: firmware.zip not found, download and place it first."
    wait_exit 1
fi

echo "Extracting firmware.zip..."
unzip -o firmware.zip -d firmware

partitions=(
    "abl"
    "aop"
    "aop_config"
    "bluetooth"
    "cpucp"
    "devcfg"
    "dsp"
    "featenabler"
    "hyp"
    "imagefv"
    "keymaster"
    "modem"
    "qupfw"
    "shrm"
    "tz"
    "uefi"
    "uefisecapp"
    "xbl"
    "xbl_config"
    "xbl_ramdump"
)

tools_path="platform-tools-linux"
[ "$(uname -s)" = "Darwin" ] && tools_path="platform-tools-darwin"

for partition in ${partitions[@]}; do
    echo -e "\nFlashing $partition..."
    if ! "./$tools_path/fastboot" flash ${partition}_ab firmware/firmware-update/$partition.img; then
        echo -e "\nError: Flashing $partition failed!"
        wait_exit 1
    fi
done

echo -e "\nCompleted succesfully!"
wait_exit
