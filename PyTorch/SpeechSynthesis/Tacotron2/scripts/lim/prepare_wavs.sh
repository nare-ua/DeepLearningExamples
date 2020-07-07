#!/usr/bin/env bash

set -eux -o pipefail

TMP=/mnt/tmp
srcroot="/mnt/data/datasets/lim"
dataroot="$TMP/datasets/lim"

rm -rf $dataroot

rsync -av --exclude '*.zip' $srcroot/* $dataroot

# relace space in filename with '_'
for fn in $dataroot/**/*; do 
  mv "$fn" $(echo "$fn" | tr ' ' '_')
done

rm -rf $dataroot/wavs
mkdir -p $dataroot/wavs

for fn in $dataroot/**/*.wav $dataroot/**/*.mp3; do
  bn="$(basename "$fn")"
  outfn="$dataroot/wavs/${bn%.*}.wav"
  echo "$fn --> $outfn"
  sox "$fn" -b16 -c1 -r22050 "$outfn" vol 24.31 dB
done

filelists_combined=$(mktemp /mnt/tmp/lim.XXXXXXXXX)
(find $dataroot -path "$dataroot/wavs" -prune -o -name "*.txt" -print|xargs cat|sed 's/\r//'|awk NF|sort) > $filelists_combined

# remove a space after '|'
sed -i 's/| /|/g' "$filelists_combined"

wavfilelists=$(mktemp /mnt/tmp/lim.XXXXXXXXX)
melfilelists=$(mktemp /mnt/tmp/lim.XXXXXXXXX)

python <<EOF
with open('${filelists_combined}', 'r', encoding='utf-8-sig') as inf,\
  open('${wavfilelists}','w') as outf,\
  open('${melfilelists}','w') as mel_outf:

  for line in inf:
    line = line.strip()
    if line != '':
      w, t = line.split('|')
      w = w.strip().replace(' ', '_')
      t = t.strip()
      wav_line = "${dataroot}/wavs/" + w + ".wav" + "|" + t
      mel_line = "${dataroot}/mels/" + w + ".pt" + "|" + t
      outf.write(wav_line+'\n')
      mel_outf.write(mel_line+'\n')
EOF

TRAINLIST="$dataroot/filelists/audio_text_train_filelist.txt"
VALLIST="$dataroot/filelists/audio_text_val_filelist.txt"

TRAINLIST_MEL="$dataroot/filelists/mel_text_train_filelist.txt"
VALLIST_MEL="$dataroot/filelists/mel_text_val_filelist.txt"


mkdir $dataroot/filelists

head -10 $wavfilelists > $VALLIST
tail -n +11 $wavfilelists > $TRAINLIST

head -10 $melfilelists > $VALLIST_MEL
tail -n +11 $melfilelists > $TRAINLIST_MEL

rm -f $wavfilelists $melfilelists $filelists_combined

#python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$TRAINLIST" --mel-files "$TRAINLIST_MEL"
#python preprocess_audio2mel.py --text-cleaners "transliteration_cleaners" --wav-files "$VALLIST" --mel-files "$VALLIST_MEL"
