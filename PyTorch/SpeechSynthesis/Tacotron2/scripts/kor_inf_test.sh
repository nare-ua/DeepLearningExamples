#!/bin/env bash

set -euo pipefail

trap ctrl_c INT
function ctrl_c() {
  echo "** Trapped CTRL-C"
  exit 1
}

#checkpoint="/mnt/data/pretrained/kss/checkpoint_Tacotron2_6000"
checkpoint="/mnt/data/checkpoints/output_iu_tacotron2/checkpoint_Tacotron2_6500"

for s in 1 2 3 4 5 6 7; do
  python inference.py --tacotron2 "$checkpoint" --waveglow /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp \
	  -o output/ --include-warmup \
	  -i phrases/kor/example_$s.txt \
	  --amp-run --wn-channels 256 \
	  --sigma-infer 0.9 \
	  --gate-threshold 0.5 \
	  --suffix $s
done
