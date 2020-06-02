#### NOTE
1. investigate sox convert warning issues
2. keep korean in filelists for readability?

#### HOWTO
0. dataroot=/mnt/data/datasets/kaggle/kss
1. downsample wav file to 22.5k: `kss_downsample.sh`
2. build filelists: `python kss_proc.py`
3. convert to mels: `prepare_mels.sh`
