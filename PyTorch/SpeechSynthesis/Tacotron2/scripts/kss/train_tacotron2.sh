#!/usr/bin/env bash

set -euxo pipefail

trainfiles=/mnt/data/datasets/kaggle/kss/filelists/mel_text_train_filelist.txt
valfiles=/mnt/data/datasets/kaggle/kss/filelists/mel_text_val_filelist.txt
outputroot=/mnt/data/checkpoints

outputdir=$outputroot/output_kss_tacotron_nc4
mkdir -p $outputdir
echo $outputdir
# prameter following scripts/train_tacotron2.sh
# set epochs to 6001 since it's the epoch number of the pretrained model 
# set text-cleaners to 'transliteration_cleaners'
# other params are kept
# issue with detection of cpu type in OpenBLAS fails (OPENBLAS_CORETYPE=nehalem)
# see https://github.com/xianyi/OpenBLAS/issues/2067 or search similar
OPENBLAS_CORETYPE=nehalem python -m multiproc train.py -m Tacotron2 \
 --learning-rate 1e-3 --epochs 6001 --batch-size 280 --weight-decay 1e-6 --grad-clip-thresh 1.0 \
 --load-mel-from-disk --training-files=$trainfiles --validation-files=$valfiles \
 --log-file nvlog.json --anneal-steps 500 1000 1500 2000 --anneal-factor 0.1 \
 --output $outputdir \
 --text-cleaners "transliteration_cleaners" \
 --amp-run --cudnn-enabled
