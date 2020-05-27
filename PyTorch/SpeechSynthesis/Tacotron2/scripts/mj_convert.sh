# convert mp3 to wav files
# a la LJ dataset
dataroot="/mnt/data/datasets/MJ"
#mkdir -p $dataroot/wavs
for d in MJ002_0001~0078 MJ002_0101~0140 MJ002_0201~0216; do
  for fn in $dataroot/$d/*.mp3; do
    bn=$(basename $fn)
    echo $fn "-->" $dataroot/wavs/${bn%.*}.wav
    # 16 bit/1 channel/22.05k sampling rate
    sox $fn -b16 -c1 -r22050 -V3 $dataroot/wavs/${bn%.*}.wav 
  done
done

# fix filename '_' to '-'
# cd $dataroot/wav
#python <<EOF
#import glob
#import shutil
#for f in glob.glob('*.wav'):
#  if f.find('_') != -1:
#    newf = f.replace('_', '-')
#    shutil.move(f, newf)
#<<

# build fileslist files
# inside /mnt/data/datasets/MJ
# cd $dataroot/wav
# (find . -name *.txt -print|xargs cat |sort) > _filelists_combined

#python <<EOF
#dataroot = "/mnt/data/datasets/MJ"
#with open('./_filelists_combined') as inf,\
#  open('./filelists_combined','w') as outf,\
#  open('./filelists_combined_mel','w') as outf2:
#  for line in inf:
#    w, t = line.split('|')
#    new_line = dataroot+"/wavs/"+w + ".wav" + "|" + t
#    mel_line = dataroot+"/mels/"+w + ".pt" + "|" + t
#    outf.write(new_line)
#    outf2.write(mel_line)
#EOF

# make split files list
# mkdir -p filelists
# head -119 filelists_combined > filelists/mj_audio_text_train_filelist.txt
# tail -n +120 filelists_combined | head -10 > filelists/mj_audio_text_test_filelist.txt
# tail -n +130 filelists_combined > filelists/mj_audio_text_val_filelist.txt
# head -119 filelists_combined_mel > filelists/mj_mel_text_train_filelist.txt
# tail -n +120 filelists_combined_mel | head -10 > filelists/mj_mel_text_test_filelist.txt
# tail -n +130 filelists_combined_mel > filelists/mj_mel_text_val_filelist.txt
