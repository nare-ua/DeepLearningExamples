#!/bin/env bash

set -euo pipefail

# convert mp3 to wav files 
dataroot="/mnt/data/datasets/MJ"

echo -n "Creating filelists ..."
# build fileslist files
cd $dataroot
(find . -name MJ*.txt -print|xargs cat |sort) > _filelists_combined

# with eos(;)
# sed -i 's/$/;/' _filelists_combined

# append (.) if not
sed -i 's/[a-zA-Z]$/&./' _filelists_combined

python <<EOF
with open('./_filelists_combined') as inf,\
  open('./filelists_combined','w') as outf,\
  open('./filelists_combined_mel','w') as mel_outf:
  for line in inf:
    w, t = line.split('|')
    new_line = "${dataroot}/wavs/" +w + ".wav" + "|" + t
    mel_line = "${dataroot}/mels/" +w + ".pt" + "|" + t
    outf.write(new_line)
    mel_outf.write(mel_line)
EOF

if [[ -d $dataroot/filelists ]]; then
  echo "please remove '$dataroot/filelists' manually"
  exit 1
fi

# make split files list
cd $dataroot
mkdir -p filelists
#head -10 filelists_combined > filelists/mj_audio_text_val_filelist.txt
#tail -n +11 filelists_combined > filelists/mj_audio_text_train_filelist.txt
cat filelists_combined > filelists/audio_text_train_filelist.txt
# test set not really needed/used
#tail -n +120 filelists_combined | head -10 > filelists/mj_audio_text_test_filelist.txt
#head -10 filelists_combined_mel > filelists/mj_mel_text_val_filelist.txt
#tail -n +11 filelists_combined_mel > filelists/mj_mel_text_train_filelist.txt
cat filelists_combined_mel > filelists/mel_text_train_filelist.txt
#tail -n +120 filelists_combined_mel | head -10 > filelists/mj_mel_text_test_filelist.txt
echo "done"

# remove temporary files
rm -f filelists_combined filelists_combined_mel _filelists_combined
