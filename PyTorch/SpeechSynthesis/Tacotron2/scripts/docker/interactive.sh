#!/bin/bash

docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -it --rm --expose 8888 -p 8888 --ipc=host -v $PWD:/workspace/tacotron2 -v /mnt/data:/mnt/data tacotron2 bash
