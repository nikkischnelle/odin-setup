#!/bin/bash

LOCK_FILE=/var/lock/gungnir_apps.lock

RCLONE_OPTIONS="-L"
RSYNC_OPTIONS="-a --partial --delete"

HOMEDIR_BASE="/Gungnir/apps"
ERROR_LOG="/tmp/backup_error_log.txt"
EMAIL="root"

if [ -f "$LOCK_FILE" ]; then
    # If it does, exit and do nothing
    echo "Lock already held. Exiting."
    exit 0
fi


# Clear any previous error log
> "$ERROR_LOG"

echo $$ > "$LOCK_FILE"
echo "Running rsync..."

# Loop through each directory in the base home directory
for user_home in "$HOMEDIR_BASE"/*; do
    # Check if it is a directory
    if [ -d "$user_home" ]; then
        # Extract the username from the directory path
        username=$(basename "$user_home")
        
        # Path to the backup script for this user
        backup_script="$user_home/backup.sh"
        
        # Check if the backup script exists and is executable
        if [ -x "$backup_script" ]; then
            echo "Running backup for user: $username"
            
            # Execute the backup script as the user and capture output
            su - "$username" -c "$backup_script" > /tmp/backup_output_${username}.txt 2>&1
            
            # Check if the script executed successfully
            if [ $? -eq 0 ]; then
                echo "Backup completed successfully for user: $username"
            else
                echo "Backup failed for user: $username" | tee -a "$ERROR_LOG"
                cat /tmp/backup_output_${username}.txt >> "$ERROR_LOG"
            fi
            # Clean up temporary output file
            rm /tmp/backup_output_${username}.txt
        else
            echo "No executable backup script found for user: $username"
        fi
    fi
done

echo "Running rsync and rclone..."

rsync $RSYNC_OPTIONS -z /Balmung/backup/apps/* root@apollo:/mnt/orpheus/backup/Odin/Gungnir/apps >> /tmp/rsync_output.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Rsync to apollo failed" | tee -a "$ERROR_LOG"
    cat /tmp/rsync_output.txt >> "$ERROR_LOG"
fi

sshpass -p "$(cat /root/laga_pass)" sudo rsync $RSYNC_OPTIONS /Balmung/backup/apps/* sshd@192.168.10.7:/shares/backup/Gungnir/apps >> /tmp/rsync_output.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Rsync to laga failed" | tee -a "$ERROR_LOG"
    cat /tmp/rsync_output.txt >> "$ERROR_LOG"
fi

rsync $RSYNC_OPTIONS /Balmung/backup/apps/* idun:/mnt/2tb/Gungnir/apps >> /tmp/rsync_output.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Rsync to idun failed" | tee -a "$ERROR_LOG"
    cat /tmp/rsync_output.txt >> "$ERROR_LOG"
fi

# rclone sync $RCLONE_OPTIONS /Balmung/backup/apps fafnir-crypt:/Gungnir/apps >> /tmp/rclone_output.txt 2>&1
# if [ $? -ne 0 ]; then
#     echo "Rclone sync to fafnir-crypt failed" | tee -a "$ERROR_LOG"
#     cat /tmp/rclone_output.txt >> "$ERROR_LOG"
# fi

echo "Rsync and rclone completed."
rm "$LOCK_FILE"

# Check if there were any errors and send the summary email
if [ -s "$ERROR_LOG" ]; then
    mail -s "Backup Script Errors" "$EMAIL" < "$ERROR_LOG"
    echo "Summary email sent to $EMAIL"
else
    echo "All backups completed successfully. No email sent."
    /root/uptime-push.sh MFjf6XFrOs
fi

# Clean up the error log file
rm "$ERROR_LOG"

