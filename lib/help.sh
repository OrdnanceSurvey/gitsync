#!/bin/bash
DIR=`dirname $0`
source "${DIR}/common.sh" 
cat "${DIR}/helpfile"

if [ -f $SYNC_FILE ]; then
	echo "\nThis is a gitsync workspace:\n\n"
	source $SYNC_FILE
	echo "Project name: ${REPO_NAME}"
	echo "Source repo: ${SOURCE_REPO}"
	echo "Target repo: ${TARGET_REPO}"
fi

if [ -f $LOG_FILE ]; then
	LAST_SYNC=$(tail -1 $LOG_FILE)
	LAST_SYNC_TIME=$(echo $LAST_SYNC | awk -F" at " '{print $2}')
	if [ -z "$LAST_SYNC" ]; then
		echo "Never been synced"
	else
		echo "Last synced at ${LAST_SYNC_TIME}"
	fi
fi