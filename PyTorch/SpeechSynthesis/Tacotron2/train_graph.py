#logfn='./output_mj_tacotron_run_B/nvlog_mj_tacotron2.json'
import sys
logfn = sys.argv[1]
import json
import time
import matplotlib.pyplot as plt
import numpy as np

while True:
  epochs, tls, vls = [], [], []
  with open(logfn, 'r') as inf:
    for line in inf:
      ln = json.loads(line.strip('\n').strip()[5:])
      print(ln)
      if len(ln['step']) == 1:
        epoch = int(ln['step'][0])
        epochs.append(epoch)
        if 'train_loss' in ln['data']:
          tl = ln['data']['train_loss']
          tls.append(tl)
        elif 'val_loss' in ln['data']:
          vl = ln['data']['val_loss']
          vls.append(vl)

  import pandas as pd
  epochs = np.unique(epochs)
  print("epoch:", len(epochs), len(vls), len(tls))
  if len(vls) == 0:
    if len(epochs) > len(tls):
      tls = tls[:epochs]
    df = pd.DataFrame({'epoch': epochs, 'tl': tls})
    y = ['tl']
  else:
    if len(epochs) > min(len(tls), len(vls)):
      tls = tls[:min(len(tls), len(vls))]
      vls = vls[:min(len(tls), len(vls))]
    df = pd.DataFrame({'epoch': epochs, 'tl': tls, 'vl': tls})
    y = ['tl', 'vl']
  fig, ax = plt.subplots(1, 1)
  df.plot(x='epoch', y=y, ax=ax)
  plt.show()
  time.sleep(3*60)
  plt.close()
