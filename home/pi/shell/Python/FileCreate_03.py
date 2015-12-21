#!/usr/bin/python

from datetime import datetime
import locale
import os.path
import time

import RPi.GPIO as GPIO
from hc_sr04 import hc_sr04

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
ultrasound = hc_sr04(11,13)
logdir="/home/pi/shell/log/"

while True:
  today = datetime.now().strftime("%Y%m%d")
  ctime = datetime.now().strftime("%H%M")
  file_Usonic = logdir + today + "_03_SENSOR.log"
  f_Usonic = open(file_Usonic, "w")
  cnt = 0
  while True:
    cnt += 1
    if cnt == 100:
      break
    distance = ultrasound.measure()
    distance = "%08d" % (distance)
    f_Usonic.write(today + ctime + "," + distance + "\n") 
    time.sleep(0.5)
