#!/bin/bash
#
# Basic intervalometer script
# 
# Modify only these variables. The rest is done for you.
# Execute either directly or via cron/at

# FIXME: Make this work with <1 frame per minute!
FRAMES_PER_MINUTE=1
HOURS_TO_RECORD=2

# FIXME: ask for location.
PHOTO_LOCATION="$HOME/testnew"

## Modify nothing below here ##
SLEEP_INTERVAL=$((60/${FRAMES_PER_MINUTE}))
TOTAL_FRAMES=$(( ${FRAMES_PER_MINUTE} * 60 * ${HOURS_TO_RECORD} ))
LOGGER="logger -s"

# record straight to CF.  There's a bug in gphoto2 that makes interval mode
# and downloading images not work together.
# [Bug Reference](https://github.com/gphoto/gphoto2/issues/265)
# Maybe one day this will be fixed and then we can auto-detect.
CAPTURE_OPT="--capture-image"

# Ensure we have all prerequisite binaries installed
for binary in gphoto2 fgrep logger; do
    which gphoto2 2> /dev/null > /dev/null
    if [[ "$?" != "0" ]]; then
        $LOGGER "unable to find $binary, exiting."
        exit 2
    fi
done

# FIXME: Check for presence of a hack for the 5Dmk3 (and Rebel T5), and if it's
# not there, add it!
# See https://github.com/gphoto/libgphoto2/issues/197 for background.
fgrep -q 'ptp2=capturetarget=card' ~/.gphoto/settings
if [[ "$?" != "0" ]]; then
	echo "Missing work-around for newer Canon bodies, applying.." | $LOGGER
	gphoto2 --set-config capturetarget=1
	if [[ $? != "0" ]]; then
		echo "Unable to apply work-around.  Exiting." | $LOGGER
	else
		echo "Work-around applied." | $LOGGER
	fi
fi

# Auto-detect camera settings.
# FIXME: If you've got multiple cameras attached, detect, and offer a menu
# at runtime.  That will help a lot, rather than fork the code and change
# the ports.  That's just silly.
CAMERA_MODEL=$(gphoto2 --auto-detect | awk -F"  " '{print $1}' | sed -n '3p')
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
gphoto2 --frames ${TOTAL_FRAMES} --interval ${SLEEP_INTERVAL}  --port "${CAMERA_PORT}" --camera "${CAMERA_MODEL}" "$CAPTURE_OPT" | $LOGGER
