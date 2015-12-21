#!/usr/bin/python
from datetime import datetime
from datetime import timedelta
import locale
import os.path
import time
import csv
import zipfile
import subprocess

logdir="/home/pi/shell/log/"

def FileUpload(type):
  now = datetime.now()
  today = now.strftime("%Y%m%d")
  ctime = datetime.now().strftime("%H%M")

  file_Status= logdir + "dateCheck.properties_" + type
  file_Log= logdir + "FileUpload_" + today + ".log"
  file_Sensor_log = logdir + today + "_" + type + "_SENSOR.log"
  file_Upload = logdir + today + ctime + "_" + type + "_Upload.txt"

  f_Status_read = open(file_Status, "r")
  f_Upload = open(file_Upload, "w")
  f_Usonic = open(file_Sensor_log, "r")
  f_Log = open(file_Log, "w")
  reader = csv.reader(f_Status_read)

  fday = today 
  fline = "0"
  for row in reader:
    fday = row[0]
    fline = row[1]
  f_Status_read.close()

  f_Log.write("Today is " + today + "\n")
  f_Log.write("last processed date: " + fday + "\n")
  f_Log.write("last processed line: " + fline + "\n")

  if fday != today:
    f_Log.write("Date changed\n")
    daybef = now - timedelta(days=+2)
    daybef = daybef.strftime("%Y%m%d")
    file_Sensor_log_old = daybef + "_" + type + "_SENSOR.log"
    zf = zipfile.ZipFile(logdir + "old/" + file_Sensor_log_old +  ".zip", "w")
    zf.write(logdir + file_Sensor_log_old, file_Sensor_log_old)
    f_Log.write(file_sensor_log_old + " moved and compressed\n")

  total = 0
  cnt = 1
  line_cnt = 1
  reader = csv.reader(f_Usonic)
  for row in reader:
    if cnt > int(fline):
      if row[1].isdigit():
        total += int(row[1])
        line_cnt += 1
    cnt += 1

  f_Status = open(file_Status, "w")
  avg = total / line_cnt 
  f_Log.write("processed " + str(line_cnt) + "\n")
  f_Log.write("average is " + str(avg) + "\n")
  f_Upload.write(type + "," + today + ctime + ",%08d\n" % avg)
  f_Status.write(today + "," + str(cnt) + "\n")
  f_Upload.close()
  f_Status.close()

  cmd = "/usr/local/bin/aws s3 cp " + file_Upload + " s3://enpit2015-sensors/" + type + "/ --profile=enpit2015 --region=us-west-2"
  import subprocess
  subprocess.call( cmd, shell=True ) 
  f_Log.write(file_Upload + " uploaded to S3\n")
  f_Log.close()
