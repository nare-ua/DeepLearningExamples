#!/usr/bin/env bash

set -e

# downsample wav file to 22.5k
dataroot="/mnt/data/datasets/kaggle/kss"

for d in 1 2 3 4; do
  mkdir -p $dataroot/wavs/$d
  mkdir -p $dataroot/tmpwavs/$d
  for fn in $dataroot/$d/*.wav; do
    bn=$(basename $fn)
    outfn="$dataroot/wavs/$d/${bn%.*}.wav"
    tmpfn="$dataroot/tmpwavs/$d/${bn%.*}.wav"
    echo "$fn --> $outfn"
    # 16 bit/1 channel/22.05k sampling rate (a la LJ dataset)
    sox $fn -b16 -c1 -r22050 $tmpfn
    sox "$tmpfn" "$outfn" silence 1 0.05 0.1% reverse silence 1 0.05 0.1% reverse;
  done
done
orglen=$(find "$dataroot/wavs" -name "*.wav" -print|xargs -I{} soxi -D {}|paste -s -d'+'|bc)
redlen=$(find "$dataroot/tmpwavs" -name "*.wav" -print|xargs -I{} soxi -D {}|paste -s -d'+'|bc)
echo "$orglen-$redlen"
echo "$orglen - $redlen"|bc -l
