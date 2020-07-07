#!/usr/bin/env bash

set -euxo pipefail

trainroot=/mnt/tmp/train/tacotron2
dataroot=/mnt/tmp/datasets/lim

waveglow_pretrained=/mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp
tacotron2_pretrained=/mnt/data/pretrained/kss/checkpoint_Tacotron2_6000

trainfiles=$dataroot/filelists/mel_text_train_filelist.txt
valfiles=$dataroot/filelists/mel_text_val_filelist.txt

outputdir=$trainroot/checkpoints/lim_tacotron2_tensorboard

mkdir -p $outputdir
python -m multiproc train.py -m Tacotron2 --checkpoint-path $tacotron2_pretrained \
 --use-saved-learning-rate true -lr 1e-6 --epochs 7001 --batch-size 32 --grad-clip-thresh 1.0 \
 --weight-decay 1e-6 \
 --load-mel-from-disk --training-files=$trainfiles --validation-files=$valfiles \
 --log-file nvlog.json --anneal-steps 6300 --anneal-factor 0.1 \
 --output $outputdir \
 --amp-run --cudnn-enabled \
 --epochs-per-checkpoint 1 \
 --text-cleaners "transliteration_cleaners" \
 --waveglow-checkpoint ${waveglow_pretrained} 
 #--freeze-embedding
