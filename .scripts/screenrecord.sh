#!/bin/bash

timestamp=$(date +"%Y%m%d-%H%M%S")
cd ~/Videos/Screenrecords/
wf-recorder -a -r 60 --sample-rate 32000 -f $timestamp.mp4 &
notify-send --app-name=wf-recorder --expire-time=1000 "Screenrecording in progress"
