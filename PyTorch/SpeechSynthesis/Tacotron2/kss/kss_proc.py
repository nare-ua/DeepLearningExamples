import pathlib
from unidecode import unidecode

transcript_fn = 'transcript.v.1.4.txt'
dataroot = pathlib.Path('/mnt/data/datasets/kaggle/kss')
with open(dataroot/transcript_fn, 'r') as inf:
  for line in inf:
    line = line.rstrip('\n')
    # use k2 as k2 doens't include Araibian number
    # k3 doen't seemt to all correct
    _path, _, k2, _, dur, eng = line.split('|')
    print(_path, unidecode(k2))
