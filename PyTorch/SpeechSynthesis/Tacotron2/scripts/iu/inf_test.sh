trap ctrl_c INT
function ctrl_c() {
  echo "** Trapped CTRL-C"
  exit 1
}

# defaults: sigma-infer=0.9 & gate-threshold=0.5 

epoch=$1
outdir=output_mj
checkpointsdir=/mnt/data/checkpoints/output_mj_tacotron2_run_fr_em_short
mkdir -p $outdir
#for p in "example.txt" "phrase.txt"; do
for p in "phrase.txt"; do
  python inference.py --tacotron2 $checkpointsdir/checkpoint_Tacotron2_${epoch:-6050} --waveglow /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp \
	  -o $outdir/ --include-warmup \
	  -i phrases/$p \
	  --amp-run --wn-channels 256 \
	  --sigma-infer 0.8 \
	  --gate-threshold 0.3 \
	  --suffix ${p%.txt}
done
