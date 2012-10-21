#!/bin/bash
KITCHEN=/opt/kaltura/dwh/pentaho/pdi/kitchen.sh
ROOT_DIR=@BASE_DIR@/dwh
WHEN=$(date +%Y%m%d)

while getopts "k:p:" o
do	case "$o" in
    k)	KITCHEN="$OPTARG";;
    p)	ROOT_DIR="$OPTARG";;
	[?])	echo >&2 "Usage: $0 [-k  pdi-path] [-p dwh-path]"
		exit 1;;
	esac
done

LOGFILE=$ROOT_DIR/logs/etl_daily-${WHEN}.log

export KETTLE_HOME=$ROOT_DIR
sh $KITCHEN /file $ROOT_DIR/etlsource/execute/daily.kjb >> $LOGFILE 2>&1
