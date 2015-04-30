#!/bin/bash
export DIR=`dirname $0`
source "${DIR}/common.sh" 

if [ -d $WORKDIR ]; then
	rm -rf $WORKDIR
	echo "Cleaned"
else
	echo "Nothing to do"
fi