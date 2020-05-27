mkdir -p output
weight_file=/mnt/data/pretrained/tacotron2/tacotron2_1032590_6000_amp
#TODO: pretrained models having epoch 6001; so adjusting epoch from 6001 to 6200
python -m multiproc train.py -m Tacotron2 -o output/ --checkpoint-path $weight_file --amp-run -lr 1e-3 --epochs 6200 -bs 38 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --load-mel-from-disk --training-files=/mnt/data/datasets/MJ/filelists/mj_mel_text_train_filelist.txt --validation-files=/mnt/data/datasets/MJ/filelists/mj_mel_text_val_filelist.txt --log-file nvlog.json --anneal-steps 500 1000 1500 --anneal-factor 0.3
