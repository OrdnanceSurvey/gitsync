#!/bin/bash
set -e
export SOURCE_REPO=
export TARGET_REPO=
export DIR=`dirname $0`
export TMP_DIR="${DIR}/git_tmp_dir"

validate_args() {

   if [ -z $SOURCE_REPO ]; then
    echo "Source repository not set"
    help
    exit -1
  fi

  if [ -z $TARGET_REPO ]; then
    echo "Target repository not set"
    help
    exit -1
  fi

}

do_sync() {
   echo "Sync changes from ${SOURCE_REPO} into ${TARGET_REPO}"
   echo ".........................."
   rm -rf $TMP_DIR
   git clone --mirror $SOURCE_REPO $TMP_DIR
   cd $TMP_DIR
   git remote set-url --push origin $TARGET_REPO
   git fetch -p origin
   git push --mirror
   echo "Mirrored"
   rm -rf $TMP_DIR
}   

help() {
  cat <<EOF

  gitsync - syncs two git remotes

  Usage: 
  
      gitsync oneshot -s <source repo> -t <target repo>


EOF
exit
}

while getopts :s:t: OPT
do case "$OPT" in
  s) SOURCE_REPO=$OPTARG;;
  t) TARGET_REPO=$OPTARG;;
  ?) help;;
  esac
done

do_sync
