import pathlib
import os
from unidecode import unidecode

train_split=0.95 # train/val: 95%/5%

transcript_fn = 'transcript.v.1.4.txt'
dataroot = pathlib.Path('/mnt/data/datasets/kaggle/kss')
wavsroot = dataroot/'wavs'
melsroot = dataroot/'mels'
filelistsroot = dataroot/'filelists'

os.makedirs(filelistsroot, exist_ok=True)

lines = []
with open(dataroot/transcript_fn, 'r') as inf:
  for line in inf:
    line = line.rstrip('\n')
    # use k2 as k2 doens't include Araibian number
    # k3 doen't seemt to all correct
    _path, _, k2, _, dur, eng = line.split('|')
    lines.append([_path, unidecode(k2)])

num_train_lines = int(len(lines)*train_split)

print("train/val: {}/{}".format(num_train_lines, len(lines) - num_train_lines))

print("creating filelists...", end="")
def dump_filelists(audoutf, meloutf):
  for w, txt in lines[:num_train_lines]:
      aud_line = str(wavsroot) + "/" + w + "|" + txt
      r, _ = os.path.splitext(w)
      mel_line = str(melsroot) + "/" + f"{r}.pt" + "|" + txt
      audoutf.write(aud_line+'\n')
      meloutf.write(mel_line+'\n')

with open(filelistsroot/'audio_text_train_filelist.txt', 'w') as audoutf,\
  open(filelistsroot/'mel_text_train_filelist.txt', 'w') as meloutf:
    dump_filelists(audoutf, meloutf)

with open(filelistsroot/'audio_text_val_filelist.txt', 'w') as audoutf,\
  open(filelistsroot/'mel_text_val_filelist.txt', 'w') as meloutf:
    dump_filelists(audoutf, meloutf)

print("done")
