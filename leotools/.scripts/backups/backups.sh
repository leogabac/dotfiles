#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
# you can verify the uuid by running

# lsblk -o NAME,LABEL,UUID,MOUNTPOINT

# ===== DETECTING THE DISK ===== #
LABEL="bloodraven"
UUID="3B479ACA6574FECE"
MOUNT_POINT=$(findmnt -rn -S UUID=$UUID -o TARGET)


if [ -z "$MOUNT_POINT" ]; then
  echo -e "${RED}[ERROR] Drive with label $LABEL not mounted. Exiting.${NC}"
  exit 1
fi

echo -e "[${GREEN}OK${NC}] Disk ${MAGENTA}${LABEL}${NC} mounted at ${MAGENTA}${MOUNT_POINT}${NC}"


# ===== PREPARING FOR BACKUP ===== #
HOSTNAME=$(uname -n)
BACKUP_DIR="$MOUNT_POINT/pc_backups/$HOSTNAME"

if [ ! -d "$BACKUP_DIR" ]; then
  echo -e "[${YELLOW}INFO${NC}] Creating directory ${MAGENTA}$BACKUP_DIR${NC}"
  mkdir -p "$BACKUP_DIR"
fi

echo -e "[${GREEN}OK${NC}] Found backup directory ${MAGENTA}$BACKUP_DIR${NC}"

DIRS_TO_SYNC=(
  "$HOME/Desktop"
  "$HOME/shorui"
)

# Sync each directory
for DIR in "${DIRS_TO_SYNC[@]}"; do
  if [ -d "$DIR" ]; then

    echo -e "[${YELLOW}INFO${NC}] Syncing ${MAGENTA}$DIR${NC}"
    # rsync -avh --delete "$DIR" "$BACKUP_DIR/"

    rsync -avh --progress "$DIR" "$BACKUP_DIR/"

    echo -e "[${GREEN}OK${NC}] Synced ${MAGENTA}$DIR${NC}"
  else
    echo -e "${RED}[ERROR] Directory $DIR does not exist.${NC}"
  fi
done

echo -e "[${GREEN}OK${NC}] Backup completed"

