#!/bin/bash

echo "backing up nemesis block"
sudo mv data/00000/00001.dat data/00000/hashes.dat /tmp
echo "deleting data directory"
for dir in data/*; do
    sudo rm -rf $dir
done

if [ -d "mongodata" ]; then
    echo "deleting mongodata directory"
    for dir in mongodata/*; do
        sudo rm -rf $dir
    done
fi
mkdir data/00000
sudo mv /tmp/00001.dat /tmp/hashes.dat data/00000/

if [ ! -f "data/index.dat" ]; then
  echo "No index.dat file, creating now...."
  echo -ne "\01\0\0\0\0\0\0\0" > data/index.dat
fi

echo "data has been reset to nemesis block"
