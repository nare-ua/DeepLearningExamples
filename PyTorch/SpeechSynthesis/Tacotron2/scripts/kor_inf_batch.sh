#!/bin/env bash

set -euo pipefail

trap ctrl_c INT
function ctrl_c() {
  echo "** Trapped CTRL-C"
  exit 1
}

inf () {
  local checkpointroot="/mnt/data/checkpoints/lim_tacotron2_finetune_postnet/checkpoint_Tacotron2"
  checkpoint="${checkpointroot}_$1"
  echo "run with checkpoint $checkpoint"
  python inference.py --tacotron2 "$checkpoint" --waveglow /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp \
	  -o output/ --include-warmup \
	  -i phrases/kor/example_1.txt \
	  --wn-channels 256 \
	  --sigma-infer 0.9 \
	  --gate-threshold 0.5 \
	  --suffix $1 \
    --cpu-run
}


for cp in {6300..6700..100}; do
	inf "$cp"
done
