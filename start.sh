#!/bin/bash
if [[ $B2_ACCOUNT_ID == "" ]]; then
	echo "Missing B2 Account ID";
	exit 1;
fi
if [[ $B2_ACCOUNT_KEY == "" ]]; then
	echo "Missing B2 Account Key";
	exit 1;
fi
if [[ $RESTIC_REPOSITORY == "" ]]; then
	echo "Missing B2 Repository name";
	exit 1;
fi
if [[ $RESTIC_REPOSITORY != b2:* ]]; then
	RESTIC_REPOSITORY="b2:$RESTIC_REPOSITORY"
fi

exclude_file="/etc/restic/exclude.lst"

if ! restic cat config >/dev/null 2>&1; then
	echo "Repository doesn't exists. Creating it..."
	if ! restic init; then
		echo "Unable to initialize repository"
		exit 1
	fi
fi

if [[ ! -f "$exclude_file" ]]; then
	touch "$exclude_file"
fi

if restic --exclude-caches --exclude-file="$exclude_file" backup /mnt/backup/; then
restic forget --keep-last $KEEP_LAST \
  --keep-daily $KEEP_DAILY \
  --keep-weekly $KEEP_WEEKLY \
  --keep-monthly $KEEP_MONTHLY \
  --keep-yearly $KEEP_YEARLY \
  --limit-upload $MAX_UPLOAD_KB \
  --prune
fi
