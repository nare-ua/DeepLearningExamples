#mkdir -p output
pretrained=/mnt/data/pretrained/tacotron2/tacotron2_1032590_6000_amp
outputroot=/mnt/data/checkpoints
trainfiles=/mnt/data/datasets/MJ/filelists/mj_mel_text_train_filelist.txt
valfiles=/mnt/data/datasets/MJ/filelists/mj_mel_text_val_filelist.txt

# run short version
checkpointpath=$pretrained
outputdir=$outputroot/output_mj_tacotron2_run_fr_em_short
mkdir -p $outputdir
trainfiles=/mnt/data/datasets/MJ/filelists/mel_text_train_filelist_0001.txt
python -m multiproc train.py -m Tacotron2 --checkpoint-path $checkpointpath \
 --learning-rate 1e-5 --epochs 6101 --batch-size 2 --weight-decay 1e-6 --grad-clip-thresh 1.0 \
 --load-mel-from-disk --training-files=$trainfiles \ #--validation-files=$valfiles \
 --log-file nvlog.json --anneal-steps 6050 6100 6200 --anneal-factor 0.3 \
 --output $outputdir \
 --amp-run --cudnn-enabled \
 --epochs-per-checkpoint 10 \
 --no-validation  \
 --freeze-embedding
