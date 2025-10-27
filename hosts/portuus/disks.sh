#!/usr/bin/env bash

SSD1='/dev/disk/by-id/ata-MTFDDAK512TBN-1AR1ZABHA_UFZMT01J1AGPW4'
SSD2='/dev/disk/by-id/ata-MTFDDAK512TBN-1AR1ZABHA_UFZMT01J1AGQPH'
HDD1='/dev/disk/by-id/ata-ST4000DM004-2CV104_ZFN3P7XE'
HDD2='/dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT3RLNM'
HDD3='/dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT3S0T7'
HDD4='/dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT3S1Z3'
MNT='/mnt'
SWAP_GB=32


# Helper function to wait for devices
wait_for_device() {
  local device=$1
  echo "Waiting for device: $device ..."
  while [[ ! -e $device ]]; do
    sleep 1
  done
  echo "Device $device is ready."
}

### SSDs ###

# Install sgdisk
nix-env -iA nixos.gptfdisk

# Ensure swap parts are off
swapoff --all
udevadm settle

# Wait for SSD devices to be ready
wait_for_device $SSD1
wait_for_device $SSD2

# Wipe filesystems
wipefs -a $SSD1
wipefs -a $SSD2

# Clear part tables
sgdisk --zap-all $SSD1
sgdisk --zap-all $SSD2

# Partition disks
sgdisk -n1:1M:+1G         -t1:EF00 -c1:BOOT1 $SSD1 # efi
sgdisk -n2:0:+"$SWAP_GB"G -t2:8200 -c2:SWAP1 $SSD1 # swap
sgdisk -n3:0:0            -t3:BF00 -c3:ROOT1 $SSD1 # solaris root
partprobe -s $SSD1
udevadm settle
wait_for_device ${SSD1}-part3

sgdisk -n1:1M:+1G         -t1:EF00 -c1:BOOT2 $SSD2
sgdisk -n2:0:+"$SWAP_GB"G -t2:8200 -c2:SWAP2 $SSD2
sgdisk -n3:0:0            -t3:BF00 -c3:ROOT2 $SSD2
partprobe -s $SSD2
udevadm settle
wait_for_device ${SSD2}-part3

# Create root pool
zpool create -f -o ashift=12 -o autotrim=on -R "$MNT" -O acltype=posixacl -O canmount=off -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa -O mountpoint=none rpool mirror ${SSD1}-part3 ${SSD2}-part3

# Create and mount root system container
zfs create -o canmount=noauto -o mountpoint=legacy rpool/root
mount -o X-mount.mkdir -t zfs rpool/root "$MNT"

# Create data sets
zfs create -o mountpoint=legacy rpool/home
zfs create -o mountpoint=legacy rpool/nix
zfs create -o mountpoint=legacy rpool/tmp
zfs create -o mountpoint=legacy rpool/var

# Mount datasets
mount -o X-mount.mkdir -t zfs rpool/home "$MNT"/home
mount -o X-mount.mkdir -t zfs rpool/nix  "$MNT"/nix
mount -o X-mount.mkdir -t zfs rpool/tmp  "$MNT"/tmp
mount -o X-mount.mkdir -t zfs rpool/var  "$MNT"/var

# Format boot and swap partitions
mkfs.vfat -F 32 -n BOOT1 "$SSD1"-part1
mkfs.vfat -F 32 -n BOOT2 "$SSD2"-part1
mkswap -L SWAP1 "$SSD1"-part2
mkswap -L SWAP2 "$SSD2"-part2

# Mount boot partition
mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1,X-mount.mkdir -L BOOT1 "$MNT"/boot

# Activate swap
swapon -L SWAP1
swapon -L SWAP2


### HDDs ###

# Wait for HDD devices to be ready
wait_for_device $HDD1
wait_for_device $HDD2
wait_for_device $HDD3
wait_for_device $HDD4

# Wipe filesystems
wipefs -a $HDD1
wipefs -a $HDD2
wipefs -a $HDD3
wipefs -a $HDD4

# Clear part tables
sgdisk --zap-all $HDD1
sgdisk --zap-all $HDD2
sgdisk --zap-all $HDD3
sgdisk --zap-all $HDD4

# Partition disks
sgdisk -n1:0:0 -t1:BF00 -c1:DATA1 $HDD1
sgdisk -n1:0:0 -t1:BF00 -c1:DATA2 $HDD2
sgdisk -n1:0:0 -t1:BF00 -c1:DATA3 $HDD3
sgdisk -n1:0:0 -t1:BF00 -c1:DATA4 $HDD4
udevadm settle

# Wait for partitions to appear
wait_for_device ${HDD1}-part1
wait_for_device ${HDD2}-part1
wait_for_device ${HDD3}-part1
wait_for_device ${HDD4}-part1

# Create mountpoint
mkdir -p "$MNT"/data

# Create data pool
zpool create -f -o ashift=12 -o autotrim=on -O acltype=posixacl -O xattr=sa -O dnodesize=auto -O compression=lz4 -O normalization=formD -O relatime=on -O mountpoint=none -R "$MNT" dpool raidz ${HDD1}-part1 ${HDD2}-part1 ${HDD3}-part1 ${HDD4}-part1

# Create and mount root system container
zfs create -o canmount=noauto -o mountpoint=legacy dpool/data
mount -o X-mount.mkdir -t zfs dpool/data "$MNT"/data

# Create data sets
zfs create -o mountpoint=legacy dpool/data/backup # TODO: move this to separate pool

zfs create -o mountpoint=legacy dpool/data/firefly-iii
zfs create -o mountpoint=legacy dpool/data/gitea
zfs create -o mountpoint=legacy dpool/data/grafana
zfs create -o mountpoint=legacy dpool/data/immich
zfs create -o mountpoint=legacy dpool/data/jellyfin
zfs create -o mountpoint=legacy dpool/data/jirafeau
zfs create -o mountpoint=legacy dpool/data/matrix-synapse
zfs create -o mountpoint=legacy dpool/data/nextcloud
zfs create -o mountpoint=legacy dpool/data/peertube
zfs create -o mountpoint=legacy dpool/data/rss-bridge
zfs create -o mountpoint=legacy dpool/data/syncthing
zfs create -o mountpoint=legacy dpool/data/tt-rss

# Mount datasets
mount -o X-mount.mkdir -t zfs dpool/data/backup         "$MNT"/data/backup

mount -o X-mount.mkdir -t zfs dpool/data/firefly-iii    "$MNT"/data/firefly-iii
mount -o X-mount.mkdir -t zfs dpool/data/gitea          "$MNT"/data/gitea
mount -o X-mount.mkdir -t zfs dpool/data/grafana        "$MNT"/data/grafana
mount -o X-mount.mkdir -t zfs dpool/data/immich         "$MNT"/data/immich
mount -o X-mount.mkdir -t zfs dpool/data/jellyfin       "$MNT"/data/jellyfin
mount -o X-mount.mkdir -t zfs dpool/data/jirafeau       "$MNT"/data/jirafeau
mount -o X-mount.mkdir -t zfs dpool/data/matrix-synapse "$MNT"/data/matrix-synapse
mount -o X-mount.mkdir -t zfs dpool/data/nextcloud      "$MNT"/data/nextcloud
mount -o X-mount.mkdir -t zfs dpool/data/peertube       "$MNT"/data/peertube
mount -o X-mount.mkdir -t zfs dpool/data/rss-bridge     "$MNT"/data/rss-bridge
mount -o X-mount.mkdir -t zfs dpool/data/syncthing      "$MNT"/data/syncthing
mount -o X-mount.mkdir -t zfs dpool/data/tt-rss         "$MNT"/data/tt-rss
