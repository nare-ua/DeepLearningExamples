# convert mp3 to wav files 
dataroot="/mnt/data/datasets/MJ"

mkdir -p $dataroot/wavs
for d in "MJ002_0001~0078" "MJ002_0101~0140" "MJ002_0201~0216" "MJ001_0001~0024"; do
  for fn in $dataroot/$d/*.mp3; do
    bn=$(basename $fn)
    echo $fn "-->" "$dataroot/wavs/${bn%.*}.wav"
    # 16 bit/1 channel/22.05k sampling rate (a la LJ dataset)
    sox $fn -b16 -c1 -r22050 "$dataroot/wavs/${bn%.*}.wav"
  done
done

# fix filename '_' to '-'
echo -n "Fixing wav filenames ..."
cd $dataroot/wavs
python <<EOF
import glob
import shutil
for f in glob.glob('*.wav'):
  if f.find('_') != -1:
    newf = f.replace('_', '-')
    shutil.move(f, newf)
EOF
echo "done"
