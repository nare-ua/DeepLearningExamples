#mkdir -p output
#pretrained=/mnt/data/pretrained/kss/checkpoint_Tacotron2_6000
#pretrained=/mnt/data/checkpoints/lim_tacotron2_finetune_postnet/checkpoint_Tacotron2_7900
pretrained=/mnt/data/checkpoints/lim_tacotron2_finetune_postnet/checkpoint_Tacotron2_6430
outputroot=/mnt/data/checkpoints
trainfiles=/mnt/data/datasets/lim/filelists/mel_text_train_filelist.txt

# run short version
checkpointpath=$pretrained
outputdir=$outputroot/lim_tacotron2_finetune_postnet
mkdir -p $outputdir
echo "start..."
python -m multiproc train.py -m Tacotron2 --checkpoint-path $checkpointpath \
 --use-saved-learning-rate true -lr 1e-6 --epochs 9000 --batch-size 32 --grad-clip-thresh 1.0 \
 --weight-decay 0 \
 --load-mel-from-disk --training-files=$trainfiles \ #--validation-files=$valfiles \
 --log-file nvlog.json --anneal-steps 7000 --anneal-factor 0.3 \
 --output $outputdir \
 --amp-run --cudnn-enabled \
 --epochs-per-checkpoint 10 \
 --text-cleaners "transliteration_cleaners" \
 --no-validation  
 #--freeze-embedding
