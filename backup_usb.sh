#!/bin/bash

# Configura il percorso del backup
DESKTOP_PATH="$HOME/Escritorio"
BACKUP_FOLDER="Backup_USB"
BACKUP_PATH="$DESKTOP_PATH/$BACKUP_FOLDER"

# Trova il punto di montaggio della chiavetta USB usando df
USB_MOUNT_POINT=$(df -h | grep "/media/$USER" | awk '{print $6}' | head -n 1)

if [ -z "$USB_MOUNT_POINT" ]; then
    echo "Errore: Nessuna chiavetta USB rilevata o montata."
    exit 1
fi

echo "Trovata chiavetta USB montata su: $USB_MOUNT_POINT"

# Verifica se il punto di montaggio esiste
if [ ! -d "$USB_MOUNT_POINT" ]; then
    echo "Errore: Il punto di montaggio $USB_MOUNT_POINT non esiste."
    exit 1
fi

# Crea la directory di backup se non esiste
mkdir -p "$BACKUP_PATH"

# Esegui il backup incrementale usando rsync
echo "Eseguendo il backup..."
rsync -av --ignore-existing "$USB_MOUNT_POINT/" "$BACKUP_PATH/"

if [ $? -eq 0 ]; then
    echo "Backup completato con successo! I file sono stati salvati in: $BACKUP_PATH"
else
    echo "Errore durante il backup. Controlla i permessi o lo stato dei file."
    exit 1
fi

