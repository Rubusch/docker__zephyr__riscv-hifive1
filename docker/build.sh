#!/bin/bash -e

export MY_HOME="/home/$(whoami)"
export BUILDDIR="${MY_HOME}/zephyrproject"
export ZEPHYR_BRANCH="v2.4-branch"


## TODO this may cost performance
sudo chown ${USER}:${USER} -R ${BUILDDIR}

if [[ ! -d "${BUILDDIR}/.west" ]]; then
    cd ${MY_HOME}
    west init ${BUILDDIR}
fi

cd ${BUILDDIR}
west update
west zephyr-export
pip3 install --user -r ${BUILDDIR}/zephyr/scripts/requirements.txt

cd ${BUILDDIR}/zephyr
git checkout ${ZEPHYR_BRANCH}

echo "READY."
echo
