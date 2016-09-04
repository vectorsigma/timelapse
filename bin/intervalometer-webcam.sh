#!/bin/bash
#
# Basic webcam intervalometer script.  Modify the variables below, but nothing
# else.
FRAMES_PER_MINUTE=1
HOURS_TO_RECORD=24
PHOTO_LOCATION="$HOME/oregon-timelapse20140714"

## Do not modify anything below.
SLEEP_INTERVAL=$((60/${FRAMES_PER_MINUTE}))
TOTAL_FRAMES=$(( ${FRAMES_PER_MINUTE} * 60 * ${HOURS_TO_RECORD} ))

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
        fswebcam --no-banner --device=/dev/video0 --resolution 1280x720 --png 9 --save frame${frameno}.png
        sleep ${SLEEP_INTERVAL}
done

