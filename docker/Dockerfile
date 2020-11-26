FROM debian:10
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

RUN apt-get install -y   \
    tzdata \
    locales \
    build-essential \
    flex \
    bison \
    libncurses5

## zephyr setup
RUN apt-get install -y   --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    wget \
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
    libsdl2-dev

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


################################################################################
## zephyr SDK
RUN mkdir -p /home/$USER/zephyrproject

RUN cd /home/$USER/zephyrproject && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.3/zephyr-sdk-0.10.3-setup.run
RUN cd /home/$USER/zephyrproject && chmod +x zephyr-sdk-0.10.3-setup.run
RUN cd /home/$USER/zephyrproject && ./zephyr-sdk-0.10.3-setup.run -- -d /home/$USER/zephyr-sdk-0.10.3

## set up 'unset preset flags' command script
RUN echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh


################################################################################
## get zephyr sources via west (regular way to install)

RUN pip3 install west
RUN cd /home/$USER/ && west init zephyrproject
RUN cd /home/$USER/zephyrproject && west update

## (opt) use my own branch
RUN cd /home/$USER/zephyrproject && rm -rf zephyr && git clone https://github.com/Rubusch/zephyr.git

## continue zephyr sources installation
RUN cd /home/$USER/zephyrproject && pip3 install -r zephyr/scripts/requirements.txt


################################################################################
## specific: board settings

RUN chown $USER:$USER -R /home/$USER

## set up tools

## bash config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.bashrc" && sudo su $USER -c "ln -s /home/$USER/configs/.bashrc /home/$USER/"

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/configs/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/configs/.emacs /home/$USER/"

## git config
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.st status"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.ci commit"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.co checkout"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.br branch"


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]