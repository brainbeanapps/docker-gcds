#!/bin/bash

# Check configuration 

if [ -z "$GCDS_CONFIG" ]; then
  echo "GCDS_CONFIG is not set! It should be set to the path of a valid Google Cloud Directory Sync config file"
  exit 1
fi

if [ -z "$GCDS_SYNC_PERIOD" ]; then
  echo "GCDS_SYNC_PERIOD is not set! It should be set to time interval how often Google Cloud Directory Sync should be performed"
  exit 1
fi

if [ ! -d "/opt/gcds/data/.java" ]; then
  mkdir -p /opt/gcds/data/.java
fi

if [ ! -d "/opt/gcds/data/.syncState" ]; then
  mkdir -p /opt/gcds/data/.syncState
fi

/opt/gcds/upgrade-config -testldap -testgoogleapps -c $GCDS_CONFIG
if [ $? -ne 0 ]; then
  echo "Failed to validate and/or upgrate configuration specified by $GCDS_CONFIG"
  exit 1
fi

# Run the synchronization
echo "Starting syncronization with $GCDS_SYNC_PERIOD synchronization period..."
while true; do
  /opt/gcds/sync-cmd -a -r /dev/stdout $GCDS_SYNC_EXTRA_ARGUMENTS -c $GCDS_CONFIG
  if [ $? -ne 0 ]; then
    echo "Failed to perform synchronization, terminating!"
    exit 1
  fi

  echo "Next syncronization will start in $GCDS_SYNC_PERIOD..."
	sleep $GCDS_SYNC_PERIOD
done
