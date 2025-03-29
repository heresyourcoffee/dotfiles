#!/bin/bash

sleep .5
if [ "$(makoctl mode)" == "default" ]; then 
	echo "N"
else
	echo "D"
fi
