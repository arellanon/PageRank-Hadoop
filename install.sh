#!/usr/bin/env bash
if [ -z "$1" ]; then
echo "Ingrese nro de workers"
exit
fi
workers=$1
sudo apt-get install bc -y
./install_giraph.sh
./download_files.sh
./project_run.sh $workers
