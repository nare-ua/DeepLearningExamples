checkpointsdir=/mnt/data/checkpoints/kss
trap ctrl_c INT
function ctrl_c() {
  echo "** Trapped CTRL-C"
  exit 1
}

epoch=$1
for s in 1 2 3 4 5; do
  python inference.py --tacotron2 $checkpointsdir/checkpoint_Tacotron2_${epoch:-1900} --waveglow /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp \
	  -o output/ --include-warmup \
	  -i phrases/kor/example_$s.txt \
	  --amp-run --wn-channels 256 \
	  --sigma-infer 0.6 \
	  --gate-threshold 0.6 \
	  --suffix $s
done
