#!/bin/bash

# This Script needs one change from the users and have some instructions how to use it, so please do read first 10 Lines of the Script.

# Clone this script in your ROM Repo using following commands.
# cd rom_repo
# curl https://raw.githubusercontent.com/unkl933/Scripts/master/script_build.sh > script_build.sh

# Some User's Details. Please fill it with your own details.

# Replace "legacy" with your own SSH Username in lowercase
username=jenkins

username=clashteam_id

# Colors makes things beautiful
export TERM=xterm

    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    blu=$(tput setaf 4)             #  blue
    cya=$(tput setaf 6)             #  cyan
    txtrst=$(tput sgr0)             #  Reset

# CCACHE UMMM!!! Cooks my builds fast

if [ "$use_ccache" = "yes" ];
then
echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export CCACHE_EXEC=/usr/bin/ccache
export USE_CCACHE=1
export CCACHE_DIR=/mnt/ccache
ccache -M 100G
export CCACHE_COMPRESS=1
fi

if [ "$use_ccache" = "clean" ];
then
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=/mnt/ccache
ccache -C
export USE_CCACHE=1
export CCACHE_COMPRESS=1
ccache -M 100G
wait
echo -e ${grn}"CCACHE Cleared"${txtrst};
fi

# Prepare Environment and Device
. build/envsetup.sh
lunch "$lunch_command"_"$device_codename"-"$build_type"

# Its Clean Time
if [ "$make_clean" = "yes" ];
then
make clean && make clobber
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
fi

# Its Images Clean Time
if [ "$make_clean" = "installclean" ];
then
make installclean
wait
echo -e ${cya}"Images deleted from OUT dir"${txtrst};
fi

# Build ROM
mka "$target_command" -j"$jobs"
