mkdir -p output
python -m multiproc train.py -m WaveGlow --checkpoint-path /mnt/data/pretrained/tacotron2/waveglow_1076430_14000_amp -o ./output/ -lr 1e-4 --epochs 100 -bs 10 --segment-length  8000 --weight-decay 0 --grad-clip-thresh 65504.0 --cudnn-enabled --cudnn-benchmark --log-file nvlog.json --amp-run
