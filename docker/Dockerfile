FROM debian:testing
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER="${USER}"

ARG ZEPHYR_BRANCH="hifive1-revb"
ARG ZEPHYR_SDK_VERSION="0.11.4"


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

## basic build and container setup
RUN apt-get install -y   \
    tzdata \
    locales \
    build-essential \
    flex \
    bison \
    libncurses5 \
    udev

## zephyr setup
RUN apt-get install -y --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    wget \
    libpython3.8 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    xz-utils \
    file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    gnutls-bin \
    usbutils

## (opt) tools for debugging and working
RUN apt-get install -y   \
    vim \
    screen \
    minicom \
    libpython2.7 \
    sudo \
    tree \
    colordiff \
    htop


################################################################################
## setup user and run stuff under user
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


################################################################################
## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers

#     
################################################################################
### ALPINE LINUX APPROACH (not working: '_STAT_VER' undeclared)
#
#FROM alpine:edge
#MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
#WORKDIR /root
#
#
#################################################################################
### the USER is needed to make it available as --build-arg
### in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
#ARG USER=""
#
### the branch
#ARG BRANCH="2020.11.x"
#
#
##################################################################################
#### set up apt fully functional
#RUN apk update && apk upgrade
#
### find package names and repositories for alpine linux:
### https://pkgs.alpinelinux.org/packages
#RUN apk add --update-cache \
#        --repository https://alpine.global.ssl.fastly.net/alpine/edge/community \
#        --repository https://alpine.global.ssl.fastly.net/alpine/edge/main \
#        --repository https://dl-3.alpinelinux.org/alpine/edge/testing \
#    alpine-sdk \
#    coreutils \
#    chrpath \
#    diffstat \
#    gawk \
#    ncurses-dev \
#    texinfo \
#    zlib \
#    zlib-dev \
#    libstdc++ \
#    bison \
#    flex \
#    binutils \
#    unzip \
#    python3 \
#    cmd:pip3 \
#    bzip2 \
#    libressl-dev \
#    sdl-dev \
#    xterm \
#    bc \
#    cpio \
#    rsync \
#    wget \
#    git \
#    cmake \
#    libxml2 \
#    libxslt \
#    debconf \
#    rpcgen \
#    diffutils \
#    sed \
#    findutils \
#    perl \
#    linux-headers \
#    m4 \
#    mercurial \
#    cvs \
#    subversion \
#    zig \
#    libc-dev \
#    bash
#
#### (opt) tools for debugging and working, e.g. X11-apps for testing the xserver via xclock
#RUN apk add \
#    gettext \
#    which \
#    vim \
#    screen \
#    sudo \
#    xclock
#
#
#################################################################################
### setup user and run stuff under user
#RUN adduser -D $USER \
#        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
#        && chmod 0440 /etc/sudoers.d/$USER
#
#RUN sed -i 's/\/bin\/ash$/\/bin\/bash/' /etc/passwd
#
#
#################################################################################
### dirty hacks...
#
#RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
#    

################################################################################
## specific: environment
USER $USER

## bash config
RUN cd /home/$USER && rm -f /home/$USER/.bashrc && ln -s /home/$USER/configs/.bashrc /home/$USER/

## vim config
RUN cd /home/$USER && rm -f /home/$USER/.vimrc && ln -s /home/$USER/configs/.vimrc /home/$USER/

## emacs config
RUN cd /home/$USER && rm -f /home/$USER/.emacs && ln -s /home/$USER/configs/.emacs /home/$USER/

## git config
RUN cd /home/$USER && git config --global alias.st status
RUN cd /home/$USER && git config --global alias.ci commit
RUN cd /home/$USER && git config --global alias.co checkout
RUN cd /home/$USER && git config --global alias.br branch
RUN cd /home/$USER && git config --global http.sslVerify false
RUN cd /home/$USER && git config --global http.postBuffer 1048576000


################################################################################
## zephyr SDK

## prepare environment
RUN cd /home/$USER && mkdir -p /home/$USER/zephyrproject
RUN ln -s /usr/local /home/$USER/.local && sudo chown $USER:$USER -R /usr/local
RUN mkdir -p /home/$USER/.local/bin && sudo chown $USER:$USER -R /home/$USER/.local

## setup west in 'zephyrproject'
RUN cd /home/$USER && export PATH=/home/${USER}/.local/bin:${PATH} && pip3 install --user -U west
RUN test ! -d /home/${USER}/zephyrproject/.west && cd /home/$USER/ && west init zephyrproject
RUN cd /home/$USER/zephyrproject && west update
RUN cd /home/$USER/zephyrproject && west zephyr-export

## (opt) use zephyr sources to install python requirements, then remove it again (will be mounted from outside)
#RUN rm -rf /home/$USER/zephyrproject/zephyr && cd /home/$USER/zephyrproject && sudo su $USER -c "git clone -j4 --depth 1 --branch ${ZEPHYR_BRANCH} https://github.com/sifive/riscv-zephyr.git zephyr"

RUN cd /home/$USER/zephyrproject && pip3 install --user -r zephyr/scripts/requirements.txt

## folder 'zephyr' will be mounted, so better remove this, to avoid some confusion with overlays...
RUN rm -rf /home/$USER/zephyrproject/zephyr

## zephyr toolchain - NB: the following typically fails with 'Error in the pull function' behind a tunneled connection
RUN cd /home/$USER && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run
RUN cd /home/$USER && chmod +x zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run
RUN cd /home/$USER && ./zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run -- -d /usr/local/zephyr-sdk-${ZEPHYR_SDK_VERSION}
RUN cd /home/$USER && rm -rf ./zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run
#RUN cd /home/$USER && sudo cp ~/zephyr-sdk-${ZEPHYR_SDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
#RUN cd /home/$USER && sudo udevadm control --reload

### (opt) set up 'unset preset flags' command script
RUN echo 'unset CFLAGS CXXFLAGS' | sudo tee -a /etc/profile.d/unset_cflags.sh


################################################################################
## command mode
USER root

## segger (...)
COPY JLink_Linux_V644e_x86_64.deb /home/$USER/JLink_Linux_V644e_x86_64.deb
RUN dpkg -i /home/$USER/JLink_Linux_V644e_x86_64.deb

COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
