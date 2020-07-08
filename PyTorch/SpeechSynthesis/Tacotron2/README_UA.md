Works with batch-size 48. Do we need to adjust learning rate?
```
python -m multiproc train.py -m Tacotron2 -o ./output/ -lr 1e-3 --epochs 1501 --batch-size 48 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --log-file nvlog.json --anneal-steps 500 1000 1500 --anneal-factor 0.1 --amp-run
```

### Training Time Estimation 
130 items per epoch
1 epoch =  442 sec ~ 7.36 mins

1501 epochs => 184.12 hours

original batch size = 104
batch sized used on ML server = 48

104/48 * 1501 * 7.36 => 23935.9 mins = 16.62 days

### inference test
```
python inference.py --tacotron2 <Tacotron2_checkpoint> --waveglow <WaveGlow_checkpoint> --wn-channels 256 -o output/ -i phrases/phrase.txt --amp-run
```

### run tensorboard
```
docker exec -it ${containderId} tensorboard --logdir ${logdir}
```
```
docker exec -it eb2ef8333652 tensorboard --logdir /mnt/tmp/train/tacotron2/checkpoints/lim_tacotron2_tensorboard/tf_events
```
