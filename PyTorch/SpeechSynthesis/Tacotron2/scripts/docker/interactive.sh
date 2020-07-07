#!/bin/bash

set -euxo pipefail

OPTARGS=""
if [[ $(hostname) == "nipa2020-0909" ]]; then
  echo "running on $(hostname)"
  OPTARGS="-e OPENBLAS_CORETYPE=nehalem"
fi

dataroot=/mnt/data
tmproot=/mnt/tmp
docker run --gpus all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -it --rm \
  --ipc=host -v $PWD:/workspace/tacotron2 \
  -v ${tmproot}:/mnt/tmp -v ${dataroot}:/mnt/data \
  -p 6006 \
  $OPTARGS tacotron2 bash
