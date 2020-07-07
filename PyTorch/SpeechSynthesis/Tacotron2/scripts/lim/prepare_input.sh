#!/usr/bin/env bash

set -e -o pipefail

TMP=/mnt/tmp
srcroot="/mnt/data/datasets/lim"
dataroot="$TMP/datasets/lim"

rsync -av $srcroot/* $dataroot

# relace space in filename with '_'
for fn in $dataroot/**/*; do mv "$fn" $(echo $fn | tr ' ' '_'); done

rm -rf $dataroot/wavs
mkdir -p $dataroot/wavs

for fn in $dataroot/**/*.wav $dataroot/**/*.mp3; do
  bn="$(basename "$fn")"
  outfn="$dataroot/wavs/${bn%.*}.wav"
  echo "$fn --> $outfn"
  sox "$fn" -b16 -c1 -r22050 "$outfn" vol 24.31 dB
done

tmpfilelists=$(mktemp /mnt/tmp/lim.XXXXXXXXX)
(find $dataroot -name "*.txt" -prune ./wavs -prune -o -print|xargs cat |awk NF|sort) > $tmpfilelists

# remove a space after '|
sed -i 's/| /|/g' $tmpfilelists

TRAINLIST="$dataroot/filelists/audio_text_train_filelist.txt"
VALLIST="$dataroot/filelists/audio_text_val_filelist.txt"

TRAINLIST_MEL="$dataroot/filelists/mel_text_train_filelist.txt"
VALLIST_MEL="$dataroot/filelists/mel_text_val_filelist.txt"

python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"
