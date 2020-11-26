# docker__zephyr__riscv-hifive1

Docker container for Sifive RISC-V HiVive1 Board.

## Resources

www.sifive.com/go/hifive1-revb-getting-started


## Build

```
$ cd ./docker/
$ time docker build --build-arg USER=$USER -t rubuschl/zephyr-hifive1:$(date +%Y%m%d%H%M%S) .
```


## Usage

In case of Tag **20191104161353**, enter the container or simply build leaving out the ``/bin/bash``
```
$ docker images
    REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/zephyr-hifive1       20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ubuntu                        xenial              5f2bf26e3524        4 days ago          123MB

$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs rubuschl/zephyr-hifive1:20191104161353 /bin/bash
```


## Target

Building the board support package (bsp) for the target, e.g. the HiFive1 board  

```
docker $> ./build.sh
docker $> source ~/env.sh
docker $> cd ~/zephyrproject
docker $> west build -b TODO samples/hello_world
```

Prepare flashing the target  

```
docker $> echo 'ATTR{idProduct}=="0204", ATTR{idVendor}=="0d28", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/50-cmsis-dap.rules
docker $> udevadm control --reload-rules
```

Serial console  

```
docker $> screen /dev/ttyACM0 115200,-parenb,cstopb,cs8
```

Flash the target  

```
docker $> west flash --erase
```

(opt) Debug the target  

```
docker $> west debug
```

Use the /dev/ttyACM0 device for debugging the target.  
