outputdir=output_waveglow
mkdir -p $outputdir
python -m multiproc train.py -m WaveGlow \
	--checkpoint-path /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp \
	-o ./$outputdir/ -lr 1e-4 --epochs 16000 -bs 10 --segment-length  8000 \
	--weight-decay 0 --grad-clip-thresh 65504.0 \
	--cudnn-enabled --cudnn-benchmark --log-file nvlog.json --amp-run \
	--training-files=/mnt/data/datasets/lim/filelists/audio_text_train_filelist.txt \
 	--no-validation \
	--wn-channels 256 \
	--load-mel-from-disk
