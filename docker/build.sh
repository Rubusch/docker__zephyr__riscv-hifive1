#!/bin/bash -e
##
## references:
## https://docs.zephyrproject.org/latest/getting_started/index.html#get-the-source-code
##

export USER="$(whoami)"
export MY_HOME="/home/${USER}"
export BUILDDIR="${MY_HOME}/zephyrproject"
#export ZEPHYR_BRANCH="v2.4-branch"
export ZEPHYR_BRANCH="hifive1-revb"

## this may cost performance, in case improve
sudo chown ${USER}:${USER} -R ${BUILDDIR}

if [[ ! -d "${BUILDDIR}/.west" ]]; then
    cd ${MY_HOME}
    west init ${BUILDDIR}
fi

cd ${BUILDDIR}
if [[ ! -d ${BUILDDIR}/zephyr/.git ]]; then
    ## get zephyr sources, if 'zephyr' (mounted) does not contain a git repo
    echo "get zephyr sources..."
    cd ${BUILDDIR}/zephyr
    #git clone https://github.com/Rubusch/zephyr.git .
    #git clone https://github.com/zephyrproject-rtos/zephyr.git .
    git clone https://github.com/sifive/riscv-zephyr.git .
    git checkout ${ZEPHYR_BRANCH}
else
    echo "zephyr sources found"
fi

## build an example
cd ~/zephyrproject/zephyr
west build -p auto -b hifive1_revb samples/basic/blinky
west flash --erase

echo "READY."
echo
