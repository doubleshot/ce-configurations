#!/bin/bash
# Kaltura dedicated Sphinx     This shell script takes care of starting and stopping a Kaltura Batch Service
#
# chkconfig: 2345 13 87
# description: Kaltura dedicated Sphinx
if [ -L $0 ];then
	REAL_SCRIPT=`readlink $0`
else
	REAL_SCRIPT=$0
fi
. `dirname $REAL_SCRIPT`/../configurations/system.ini

COMMAND="$APP_DIR/plugins/sphinx_search/scripts/watch.daemon.sh -u root"
POP_COMMAND="$APP_DIR/plugins/sphinx_search/scripts/watch.populate.sh @APP_DIR@/plugins/sphinx_search/scripts/configs/server-sphinx.php"

# Source function library
. /etc/rc.d/init.d/functions

start() {
        echo -n "Starting Sphinx Watch Daemon: "
        pgrep watch.daemon.sh  2>&1>/dev/null
        if [ $? -eq  0 ]; then
                 echo_failure
                 echo
                 exit 2;
        fi
        setsid $COMMAND 2>&1 >> /opt/kaltura/log/`basename $0`.log &
        echo_success
    echo
    
    echo -n "Starting Sphinx populateFromLog watch: "
        pgrep -f populateFromLog.php
        if [ $? -eq  0 ]; then
                 echo_failure
                 echo
                 exit 2;
        fi
        setsid $POP_COMMAND &
        echo_success
    echo
}

stop() {
		
		echo -n "Stopping Sphinx Watch Daemon: "
        #Kills the watch.dameon
		KP=$(pgrep watch.daemon.sh)
		if [[ "X$KP" != "X" ]]
		      then
				kill -9 $KP
		fi
		echo
		
		echo -n "Stopping populateFromLog.php script: "
		#kills the populate from log
		KP=$(pgrep -f populateFromLog.php)
		if [[ "X$KP" != "X" ]]
		      then
				kill -9 $KP
		fi
		echo
		
		echo -n "Stopping searchd service: "
		#kills the search service
		KP=$(pgrep searchd)
		if [[ "X$KP" != "X" ]]
		      then
				kill -9 $KP
		fi
		echo
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        start
        ;;
  *)
        echo "Usage: {start|stop|restart}"
        exit 1
esac

exit 0
