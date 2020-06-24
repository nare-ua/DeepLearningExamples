#mkdir -p output
pretrained=/mnt/data/pretrained/kss/checkpoint_Tacotron2_6000
outputroot=/mnt/data/checkpoints
trainfiles=/mnt/data/datasets/IU/tmp/filelists/mel_text_train_filelist.enc.txt

# run short version
checkpointpath=$pretrained
outputdir=$outputroot/output_iu_tacotron2
mkdir -p $outputdir
python -m multiproc train.py -m Tacotron2 --checkpoint-path $checkpointpath \
 --learning-rate 1e-5 --epochs 7000 --batch-size 32 --weight-decay 1e-6 --grad-clip-thresh 1.0 \
 --load-mel-from-disk --training-files=$trainfiles \ #--validation-files=$valfiles \
 --log-file nvlog.json --anneal-steps 6050 6100 6200 --anneal-factor 0.3 \
 --output $outputdir \
 --amp-run --cudnn-enabled \
 --epochs-per-checkpoint 10 \
 --text-cleaners "transliteration_cleaners" \
 --no-validation  
 #--freeze-embedding
