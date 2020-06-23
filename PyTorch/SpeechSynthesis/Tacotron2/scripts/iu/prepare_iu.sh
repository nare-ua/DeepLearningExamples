# convert mp3 to wav files 
dataroot="/mnt/data/datasets/IU/tmp"

# relace space in filename with '_'
#for file in **/*; do mv "$file" `echo $file | tr ' ' '_'` ; done
#
## downsampling
#rm -rf $dataroot/wavs
#mkdir -p $dataroot/wavs
#
#for fn in $dataroot/**/*.wav; do
#  bn="$(basename "$fn")"
#  outfn="$dataroot/wavs/${bn%.*}.wav"
#  echo "$fn --> $outfn"
#  sox "$fn" -b16 -c1 -r22050 "$dataroot/wavs/${bn%.*}.wav"
#done
#
#(find $dataroot -name "*.txt" -prune ./wavs -prune -o -print|xargs cat |awk NF|sort) > _filelists_combined
#for d in $dataroot/*/ ; do
#  echo $d
#  #for fn in $dataroot/$d/*.mp3; do
#  #  bn=$(basename $fn)
#  #  echo $fn "-->" "$dataroot/wavs/${bn%.*}.wav"
#  #  # 16 bit/1 channel/22.05k sampling rate (a la LJ dataset)
#  #  sox $fn -b16 -c1 -r22050 "$dataroot/wavs/${bn%.*}.wav"
#  #done
#done

# fix filename '_' to '-'
#echo -n "Fixing wav filenames ..."
#cd $dataroot/wavs
#python <<EOF
#import glob
#import shutil
#for f in glob.glob('*.wav'):
#  if f.find('_') != -1:
#    newf = f.replace('_', '-')
#    shutil.move(f, newf)
#EOF
#echo "done"

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
