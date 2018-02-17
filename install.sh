#!/usr/bin/env bash
workers=$1
./install_giraph.sh
./download_files.sh
./project_run.sh $workers
