#!/usr/bin/env bash

set -e

DATADIR="/mnt/data/datasets/IU/tmp"
FILELISTSDIR="/mnt/data/datasets/IU/tmp/filelists"

#TESTLIST="$FILELISTSDIR/mj_audio_text_test_filelist.txt"
TRAINLIST="$FILELISTSDIR/audio_text_train_filelist.txt"
VALLIST="$FILELISTSDIR/audio_text_val_filelist.txt"

#TESTLIST_MEL="$FILELISTSDIR/mj_mel_text_test_filelist.txt"
TRAINLIST_MEL="$FILELISTSDIR/mel_text_train_filelist.txt"
VALLIST_MEL="$FILELISTSDIR/mel_text_val_filelist.txt"

wavcnt=$(ls $DATADIR/wavs | wc -l)
mkdir -p "$DATADIR/mels"
if [ $(ls $DATADIR/mels | wc -l) -ne $wavcnt ]; then
    python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
    #python preprocess_audio2mel.py --wav-files "$TESTLIST" --mel-files "$TESTLIST_MEL"
    #python preprocess_audio2mel.py --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"	
fi	
