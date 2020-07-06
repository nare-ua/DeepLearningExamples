import sys
import time
logfn = sys.argv[1]
import json
import time
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from datetime import datetime

import signal
import sys
import os
def signal_handler(sig, frame):
  sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

def handle_close(evt):
  print(evt)
  pid = os.getpid()
  os.kill(pid, signal.SIGINT)

fig, ax = plt.subplots(1, 1)
fig.canvas.mpl_connect('close_event', handle_close)

while True:
  ax.clear()
  epochs, tls, vls = [], [], []
  with open(logfn, 'r') as inf:
    for line in inf:
      ln = json.loads(line.strip('\n').strip()[5:])
      if len(ln['step']) == 1:
        epoch = int(ln['step'][0])
        epochs.append(epoch)
        if 'train_loss' in ln['data']:
          tl = ln['data']['train_loss']
          tls.append(tl)
        elif 'val_loss' in ln['data']:
          vl = ln['data']['val_loss']
          vls.append(vl)

  if len(vls) == 0: # when validation is not used
    vls = tls
  epochs = np.unique(epochs)
  _min = min(len(epochs), len(tls), len(vls))
  #print("_min:", _min)
  epochs, vls, tls = epochs[:_min], vls[:_min], tls[:_min]
  df = pd.DataFrame({'epoch': epochs, 'tl': tls, 'vl': vls})
  df.plot(x = 'epoch', y = ['tl', 'vl'], ax=ax)
  #ax.set_ylim([0.1, 1.0])
  #ax.set_yscale('log')
  now = datetime.now()
  # dd/mm/YY H:M:S
  dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
  #print(dt_string, "epoch=", epochs[-1], "tl=", tls[-1], "vl=", vls[-1])
  plt.ion()
  plt.show()
  print(f"updated @ {dt_string}")
  for i in range(60):
    plt.pause(1)
    #time.sleep(1)
