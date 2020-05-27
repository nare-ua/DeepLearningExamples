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

2. train/val/test split
roughly following LJ's split (12500/100/500 = 0.95419847, 0.00763359, 0.03816794)  
134 => (119/5/10)

2. prepare mel
prepare fileslist; see `mj_convert.sh`  
go into docker (`sh scripts/docker/interactive.sh`)  
`bash scripts/prepare_mels.sh`

processed mel-spectrograms should be found in the `/mnt/data/datasets/MJ/mels`

3. train waveglow
see `sh train_mj_waveglow.sh`

4. train tacotron

### Training from scratch
Korean dataset


