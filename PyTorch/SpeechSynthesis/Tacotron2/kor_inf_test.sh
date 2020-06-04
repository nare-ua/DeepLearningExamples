for s in 1 2 3 4 5; do
  python inference.py --tacotron2 checkpoint_Tacotron2_1900 --waveglow /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp -o output/ --include-warmup -i phrases/kor/example_$s.txt --amp-run --wn-channels 256 --suffix $s
done
