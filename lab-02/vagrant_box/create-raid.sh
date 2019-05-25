#!/bin/bash

set -x
raid_level=${1:-'10'}
raid_dev='/dev/md0'
dev_count=${2:-4}
devices=$(ls /dev/sd[b-e])
device_count=$(ls /dev/sd[b-e]| wc -l)

if [[ ! -e $raid_dev ]]
then
  sudo mdadm --zero-superblock --force $devices &> /dev/null
  sudo mdadm --create --verbose $raid_dev -l $raid_level -n $device_count $devices
fi

if [[ ! -e /etc/mdadm/mdadm.conf ]]
then
  sudo mkdir -p /etc/mdadm && \
  sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf && \
  sudo mdadm --detail --scan --verbose | awk '/^ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
fi

sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%

for i in $(seq 1 5)
do
  sudo mkfs.ext4 "/dev/md0p$i" -L "part$i"
done

sudo mkdir -p /raid/part{1,2,3,4,5}

for i in $(seq 1 5)
do
  sudo mount /dev/md0p$i /raid/part$i
done
