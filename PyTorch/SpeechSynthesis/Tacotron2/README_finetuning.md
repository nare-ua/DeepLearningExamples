### Pretrained model
check official homepage to get the latest version
/mnt/data/pretrained/tacotron/*

### Datset (MJ-UA)
/mnt/data/datasets/MJ

### Procedures
1. preprocessing
  * prepare sound file
    - converting format (mp3 to wav)
    - sampling rate: 22050
    - bits: 16 bit
    - single channel
    - dither is done defulat (need to check if it's a good thing)  
      `sox $file -b16 -c1 -r22050 ${file%.*}.wav'

      ```
      $ soxi MJ002-0001.wav

      Input File     : 'MJ002-0001.wav'
      Channels       : 1
      Sample Rate    : 22050
      Precision      : 16-bit
      Duration       : 00:00:02.32 = 51244 samples ~ 174.299 CDDA sectors
      File Size      : 103k
      Bit Rate       : 353k
      Sample Encoding: 16-bit Signed Integer PCM
      ```
    - 134 files
    - 30 mins

2. cerae `filelists` (train/val/test split)
roughly following LJ's split (12500/100/500 = 0.95419847, 0.00763359, 0.03816794)  
134 => (119/5/10)
instead of splitting we put everything in the training set and examine quality
by hearing resultant voice sound

3. prepare mel
prepare fileslist; see `mj_convert.sh`  
go into docker (`sh scripts/docker/interactive.sh`)  
`bash scripts/prepare_mels.sh`

processed mel-spectrograms should be found in the `/mnt/data/datasets/MJ/mels`

### training
#### Pretrained model 
- tacotron2(`/mnt/data/pretrained/tacotron2/tacotron2_1032590_6000_amp`)

```
pretrained=/mnt/data/pretrained/tacotron2/tacotron2_1032590_6000_amp
python -m multiproc train.py -m Tacotron2 -o ./output/ -lr 1e-3 --epochs 6002 -bs 48 --weight-decay 1e-6 --grad-clip-thresh 1.0 --cudnn-enabled --log-file nvlog.json --anneal-steps 500 1000 1500 --anneal-factor 0.1 --amp-run --checkpoint-path $pretrained --use-saved-learning-rate true
```

Log output for epoch #6001
```
DLL 2020-05-28 03:32:53.154306 - (6001, 129) glob_iter/iters_per_epoch : 129/130
DLL 2020-05-28 03:32:54.425004 - (6001, 129) train_loss : 0.2885781526565552
DLL 2020-05-28 03:32:56.502714 - (6001, 129) train_items_per_sec : 17340.741383876426
DLL 2020-05-28 03:32:56.505289 - (6001, 129) train_iter_time : 3.348415082989959
DLL 2020-05-28 03:32:56.700207 - (6001,) train_items_per_sec : 16315.76090306534
DLL 2020-05-28 03:32:56.700312 - (6001,) train_loss : 0.2735373829419796
DLL 2020-05-28 03:32:56.700340 - (6001,) train_epoch_time : 436.61357499999576
DLL 2020-05-28 03:32:58.816403 - (6001, 130, 0) val_items_per_sec : 49397.70600746779
DLL 2020-05-28 03:32:59.655112 - (6001, 130, 1) val_items_per_sec : 2544.08902081116
DLL 2020-05-28 03:32:59.713274 - (6001,) val_loss : 0.4856715649366379
DLL 2020-05-28 03:32:59.713385 - (6001,) val_items_per_sec : 25970.897514139473
DLL 2020-05-28 03:32:59.714030 - () run_time : 442.85153458299465
DLL 2020-05-28 03:32:59.714071 - () val_loss : 0.4856715649366379
DLL 2020-05-28 03:32:59.714100 - () train_items_per_sec : 16315.76090306534
```

- train loss: 0.2735373829419796
- val loss: 0.4856715649366379

```
DLL 2020-05-28 06:03:58.363329 - (14001,) train_items_per_sec : 156216.86807260188 
DLL 2020-05-28 06:03:58.363436 - (14001,) train_loss : -6.157186838531494 
DLL 2020-05-28 06:03:58.363464 - (14001,) train_epoch_time : 643.3862058919913 
DLL 2020-05-28 06:03:58.673194 - (14001, 625, 0) val_items_per_sec : 790738.5146984395 
DLL 2020-05-28 06:03:58.873822 - (14001, 625, 1) val_items_per_sec : 802657.865081225 
DLL 2020-05-28 06:03:59.074199 - (14001, 625, 2) val_items_per_sec : 803089.5900013795 
DLL 2020-05-28 06:03:59.273947 - (14001, 625, 3) val_items_per_sec : 805627.7205458164 
DLL 2020-05-28 06:03:59.473283 - (14001, 625, 4) val_items_per_sec : 807138.4658287528 
DLL 2020-05-28 06:03:59.525777 - (14001,) val_loss : -6.200116920471191 
DLL 2020-05-28 06:03:59.525884 - (14001,) val_items_per_sec : 801850.4312311227 
DLL 2020-05-28 06:03:59.527747 - () run_time : 648.1534503430012 
DLL 2020-05-28 06:03:59.527789 - () val_loss : -6.200116920471191 
DLL 2020-05-28 06:03:59.527817 - () train_items_per_sec : 156216.86807260188 
```
- train loss: -6.157186838531494
- val loss: -6.200116920471191

1. train waveglow (waveglow is known to be universal and does not requrires 
finetuning)
see `sh train_mj_waveglow.sh`

2. train tacotron
see `sh train_mj_tacotron.sh`

### testing
`python inference.py --tacotron2 ./output/checkpoint_Tacotron2_6300 --waveglow ./output/checkpoint_WaveGlow_14100 -o output/ --include-warmup -i phrases/phrase_1_64.txt --amp-run --wn-channels 256`

NOTE:
- seem alignment info is destroyed and then reconstructed...
- train only postnet/or encoder/decoder - no use
- ignore text embedding (o)

TODO:
- batch size issue
- gate threshold (--gate-threshold) default: 0.5
- gate error plotting
- https://github.com/mozilla/TTS/tree/824c091  
  Note that having a validation split does not work well as oppose to other ML problems since at the validation time model generates spectrogram slices without "Teacher-Forcing" and that leads misalignment between the ground-truth and the prediction. Therefore, validation loss does not really show the model performance. Rather, you might use all data for training and check the model performance by relying on human inspection.
- EOS(;) seems (.) is more primed for EOS
- tensorboard integration for full training
- emtpy tailing silence detection
- multiple inference loop - stat
- sox noise handling  
  https://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/comment-page-2/

- voice transferred pretty fast < 6100
- possible dataset issue?
- wav file cleaning
- need to try with a clean dataset

## Network dump
```
Tacotron2(
  (embedding): Embedding(148, 512)
  (encoder): Encoder(
    (convolutions): ModuleList(
      (0): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (1): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (2): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
    )
    (lstm): LSTM(512, 256, batch_first=True, bidirectional=True)
  )
  (decoder): Decoder(
    (prenet): Prenet(
      (layers): ModuleList(
        (0): LinearNorm(
          (linear_layer): Linear(in_features=80, out_features=256, bias=False)
        )
        (1): LinearNorm(
          (linear_layer): Linear(in_features=256, out_features=256, bias=False)
        )
      )
    )
    (attention_rnn): LSTMCell(768, 1024)
    (attention_layer): Attention(
      (query_layer): LinearNorm(
        (linear_layer): Linear(in_features=1024, out_features=128, bias=False)
      )
      (memory_layer): LinearNorm(
        (linear_layer): Linear(in_features=512, out_features=128, bias=False)
      )
      (v): LinearNorm(
        (linear_layer): Linear(in_features=128, out_features=1, bias=False)
      )
      (location_layer): LocationLayer(
        (location_conv): ConvNorm(
          (conv): Conv1d(2, 32, kernel_size=(31,), stride=(1,), padding=(15,), bias=False)
        )
        (location_dense): LinearNorm(
          (linear_layer): Linear(in_features=32, out_features=128, bias=False)
        )
      )
    )
    (decoder_rnn): LSTMCell(1536, 1024, bias=1)
    (linear_projection): LinearNorm(
      (linear_layer): Linear(in_features=1536, out_features=80, bias=True)
    )
    (gate_layer): LinearNorm(
      (linear_layer): Linear(in_features=1536, out_features=1, bias=True)
    )
  )
  (postnet): Postnet(
    (convolutions): ModuleList(
      (0): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(80, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (1): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (2): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (3): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 512, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(512, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
      (4): Sequential(
        (0): ConvNorm(
          (conv): Conv1d(512, 80, kernel_size=(5,), stride=(1,), padding=(2,))
        )
        (1): BatchNorm1d(80, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True)
      )
    )
  )
)
```
