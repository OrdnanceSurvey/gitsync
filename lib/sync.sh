#!/bin/bash -vx
export DIR=`dirname $0`
source "${DIR}/common.sh" 


ensure_exists(){
	if [ ! -d "${WORKDIR}" ]; then
		echo "Work directory does not exist. Did you run gitsync init?"
		exit -1
	fi

	if [ ! -f "${SYNC_FILE}" ]; then
		echo ".gitsync does not exist. Did you run gitsync init?"
		exit -2
	fi
}

source_syncfile() {
   source ${SYNC_FILE}
   if [ -z $SOURCE_REPO ]; then
		echo "Source repository not set in .gitsync"
		exit -1
	fi

	if [ -z $TARGET_REPO ]; then
	  echo "Target repository not set in .gitsync"
	  exit -1
	fi

	if [ -z $REPO_NAME ]; then
		echo "Repo name not set in .gitsync"
		exit -2
	fi
}

do_sync() {
	cd "${WORKDIR}/${REPO_NAME}"
	git remote set-url --push origin $TARGET_REPO
  git fetch -p origin
  git push --mirror 
  echo "Synced ${SOURCE_REPO} to ${TARGET_REPO}"
}

do_log() {
	local NOW=`date`
	echo "Synced ${SOURCE_REPO} to ${TARGET_REPO} at ${NOW}" >> $LOG_FILE
}

truncate_log_if_needed() {
	if [ ! -f $LOG_FILE ]; then return; fi
	COUNT=$(wc -l < ${LOG_FILE})
	if (( $COUNT > 3 )); then
		echo "Log file over 1000 entries - cleaning up"
		: > $LOG_FILE
	fi
}

ensure_exists
source_syncfile
do_sync
truncate_log_if_needed
do_log
