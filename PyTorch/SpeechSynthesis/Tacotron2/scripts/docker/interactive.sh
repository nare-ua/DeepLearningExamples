#!/bin/bash

set -euxo pipefail

dataroot="/mnt/data"
if [[ $(hostname) == "nipa2020-0909" ]]; then
  echo "running on $(hostname)"
  dataroot="/home/ua/data"
fi
echo "dataroot($dataroot)"

docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -it --rm --expose 8888 -p 8888 --ipc=host -v $PWD:/workspace/tacotron2 -v ${dataroot}:/mnt/data tacotron2 bash
