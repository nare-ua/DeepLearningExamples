#!/usr/bin/env bash

set -eux -o pipefail
TMP=/mnt/tmp
dataroot="$TMP/datasets/lim"

TRAINLIST="$dataroot/filelists/audio_text_train_filelist.txt"
VALLIST="$dataroot/filelists/audio_text_val_filelist.txt"

TRAINLIST_MEL="$dataroot/filelists/mel_text_train_filelist.txt"
VALLIST_MEL="$dataroot/filelists/mel_text_val_filelist.txt"

mkdir -p $dataroot/mels
python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"
