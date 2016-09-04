#!/bin/bash
#
# Basic intervalometer script
# 
# Modify only these variables. The rest is done for you.
# Execute either directly or via cron/at

# FIXME: Make this work with <1 frame per minute!
FRAMES_PER_MINUTE=1
HOURS_TO_RECORD=2
PHOTO_LOCATION="$HOME/testnew"

## Modify nothing below here ##
SLEEP_INTERVAL=$((60/${FRAMES_PER_MINUTE}))
TOTAL_FRAMES=$(( ${FRAMES_PER_MINUTE} * 60 * ${HOURS_TO_RECORD} ))
LOGGER="logger -s"

# Check to see if we want to record straight to CF.  My old DSLR is
# USB 1.1, and takes ~1 Min to capture and download an image.  So setting
# FRAMES_PER_MINUTE higher than 1 is a non-starter.  Use a big CF Card
# for this option.
CAPTURE_OPT="--capture-image-and-download"
if [[ $FRAMES_PER_MINUTE > 1 ]]; then
	CAPTURE_OPT="--capture-image"
fi

# Ensure we have all prerequisite binaries installed
for binary in gphoto2; do
    which gphoto2 2> /dev/null > /dev/null
    if [[ "$?" != "0" ]]; then
        $LOGGER "unable to find $binary, exiting."
        exit 2
    fi
done

# Auto-detect camera settings.
# FIXME: it would be nice to do this without having to run --auto-detect twice!
CAMERA_MODEL=$(gphoto2 --auto-detect | egrep -o "^(.*\))")
CAMERA_PORT=$(gphoto2 --auto-detect | egrep -o "usb:.*$")

# Create the output directory, fail if you can't.  gphoto2 will store
# images in $PWD, so we need to create this directory and cd to it before
# we capture any images.
if [[ ! -d "${PHOTO_LOCATION}" ]]; then
    mkdir -p "${PHOTO_LOCATION}"
    if [[ "$?" != "0" ]]; then
        $LOGGER "Unable to create directory: ${PHOTO_LOCATION}"
        exit 1
    fi
fi

# Capture frames using gphoto2's built in intervalometer interface!
# Old version of this had a dumb for loop.
$LOGGER "Capturing ${TOTAL_FRAMES} frames, sleeping every ${SLEEP_INTERVAL} seconds."
cd ${PHOTO_LOCATION}
gphoto2 --frames ${TOTAL_FRAMES} --interval ${SLEEP_INTERVAL}  --port "${CAMERA_PORT}" --camera "${CAMERA_MODEL}" "$CAPTURE_OPT"
