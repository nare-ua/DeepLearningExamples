#!/usr/bin/env bash

set -euxo pipefail

DATAROOT="/mnt/data/datasets/kaggle/kss"
FILELISTSDIR="$DATAROOT/filelists"

#TESTLIST="$FILELISTSDIR/audio_text_test_filelist.txt"
TRAINLIST="$FILELISTSDIR/audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/audio_text_val_filelist.txt"

#TESTLIST_MEL="$FILELISTSDIR/mel_text_test_filelist.txt"
TRAINLIST_MEL="$FILELISTSDIR/mel_text_train_filelist.txt"
VALLIST_MEL="$FILELISTSDIR/mel_text_val_filelist.txt"

echo $DATAROOT/wavs
wavcnt=$(find "$DATAROOT/wavs" -name "*.wav" -print | wc -l)
echo "wav count=$wavcnt"

mkdir -p "$DATAROOT/mels/1"
mkdir -p "$DATAROOT/mels/2"
mkdir -p "$DATAROOT/mels/3"
mkdir -p "$DATAROOT/mels/4"

if [ $(ls $DATAROOT/mels | wc -l) -ne $wavcnt ]; then
    python preprocess_audio2mel.py --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    #python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
