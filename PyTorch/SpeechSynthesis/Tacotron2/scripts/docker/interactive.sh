#!/bin/bash

docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -it --rm --ipc=host -v $PWD:/workspace/tacotron2/ -v /mnt/datasets/LJSpeech-1.1:/workspace/tacotron2/LJSpeech-1.1 -v /mnt/datasets/pretrained:/mnt/datasets/pretrained tacotron2 bash
