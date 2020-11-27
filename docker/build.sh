#!/bin/bash -e

export MY_HOME=/home/$(whoami)
export BUILDDIR=${MY_HOME}/zephyrproject

## TODO this will cost performance, improve!!!      
chown ${USER}:${USER} -R ${BUILDDIR}

cd ${MY_HOME}
west init /home/$USER/zephyrproject

cd ${BUILDDIR}
west update
west zephyr-export
pip3 install --user -r ${BUILDDIR}/zephyr/scripts/requirements.txt
echo "TODO"                 

echo "READY."
echo
