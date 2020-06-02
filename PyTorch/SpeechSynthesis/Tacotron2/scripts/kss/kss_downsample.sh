#!/usr/bin/env bash

set -e

# downsample wav file to 22.5k
dataroot="/mnt/data/datasets/kaggle/kss"

mkdir -p $dataroot/wavs
for d in 1 2 3 4; do
  mkdir -p $dataroot/wavs/$d
  for fn in $dataroot/$d/*.wav; do
    bn=$(basename $fn)
    outfn="$dataroot/wavs/$d/${bn%.*}.wav"
    echo $fn "-->" "$outfn"
    # 16 bit/1 channel/22.05k sampling rate (a la LJ dataset)
    sox $fn -b16 -c1 -r22050 $outfn
  done
done
