dataroot="/mnt/data/datasets/lim"

# relace space in filename with '_'
#for fn in $dataroot/**/*; do mv "$fn" $(echo $fn | tr ' ' '_'); done

rm -rf $dataroot/wavs
mkdir -p $dataroot/wavs

for fn in $dataroot/**/*.wav $dataroot/**/*.mp3; do
  bn="$(basename "$fn")"
  outfn="$dataroot/wavs/${bn%.*}.wav"
  echo "$fn --> $outfn"
  sox "$fn" -b16 -c1 -r22050 "$outfn" vol 24.31 dB
done

#(find $dataroot -name "*.txt" -prune ./wavs -prune -o -print|xargs cat |awk NF|sort) > $dataroot/_filelists_combined

# remove a space after '|
#sed -i 's/| /|/g' $dataroot/_filelists_combined
