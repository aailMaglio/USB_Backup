#!/bin/bash

# Configure the backup path
DESKTOP_PATH="$HOME/Escritorio"
BACKUP_FOLDER="Backup_USB"
BACKUP_PATH="$DESKTOP_PATH/$BACKUP_FOLDER"

# Find the mount point of the USB stick using df
USB_MOUNT_POINT=$(df -h | grep "/media/$USER" | awk '{print $6}' | head -n 1)

if [ -z "$USB_MOUNT_POINT" ]; then
    echo "Error: No USB stick detected or mounted."
    exit 1
fi

echo "Found USB stick mounted on: $USB_MOUNT_POINT"

# Check if the mount point exists
if [ ! -d "$USB_MOUNT_POINT" ]; then
    echo "Error: Mount point $USB_MOUNT_POINT does not exist."
    exit 1
fi

# Create backup directory if it does not exist
mkdir -p "$BACKUP_PATH"

# Perform incremental backup using rsync
echo "Backing up..."
rsync -av --ignore-existing "$USB_MOUNT_POINT/" "$BACKUP_PATH/"

if [ $? -eq 0 ]; then
    echo "Backup completed successfully! Files have been saved to: $BACKUP_PATH"
else
    echo "Error during backup. Check file permissions or status."
    exit 1
fi
