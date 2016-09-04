#!/bin/bash
#
# Basic webcam intervalometer script.  This one differs from the other
# intervalometer in that it is designed to capture more slow moving types
# of events.  Rather than "frames/minute", it's geared towards "Take a frame
# every X minutes". 
#
# Modify the variables below, but nothing else.
#
MINUTES_PER_FRAME=10
HOURS_TO_RECORD=720
PHOTO_LOCATION="$HOME/coffee-spores/coffee-spores"

## Do not modify anything below.
SLEEP_INTERVAL="${MINUTES_PER_FRAME}m"
TOTAL_FRAMES=$(( 60 / ${MINUTES_PER_FRAME} * ${HOURS_TO_RECORD} ))

# Check prerequisite software
FAILCOUNT=0
for binary in fswebcam uvcdynctrl; do
        which $binary 2> /dev/null > /dev/null
        if [[ "$?" != "0" ]]; then
                logger "Unable to find $binary!"
                FAILCOUNT=$(( $FAILCOUNT + 1 ))
        fi
        if [[ $FAILCOUNT -gt 0 ]]; then
                logger "exiting..."
                exit 1
        fi
done

# Create destination directory
if [[ ! -d "${PHOTO_LOCATION}" ]]; then
        mkdir -p "${PHOTO_LOCATION}"
        if [[ "$?" != "0" ]]; then
                logger "Unable to make directory, $PHOTO_LOCATION"
                exit 2
        fi
fi

# Capture images
cd "$PHOTO_LOCATION"
for frameno in $(seq -w 0 ${TOTAL_FRAMES}); do
        fswebcam --no-banner --device=/dev/video1 --resolution 1280x720 --png 9 --save frame${frameno}.png
        sleep ${SLEEP_INTERVAL}
done

