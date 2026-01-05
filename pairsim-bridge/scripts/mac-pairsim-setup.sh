#!/usr/bin/env bash

wget https://github.com/alvinye9/Purdue-AI-Racing-Simulator/releases/download/v8.3.4_macOs/PAIRSim_v8.3.4_MacOS.zip
unzip PAIRSim_v8.3.4_MacOS.zip && mv PAIRSim_v8.3.4_MacOS/PAIRSim_v8.3.4_MacOS.app PAIRSim.app
rm -rf PAIRSim_v8.3.4_MacOS PAIRSim_v8.3.4_MacOS.zip

chmod +x PAIRSim.app/Contents/MacOS/PAIRSIM