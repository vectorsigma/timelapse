#!/bin/bash
#
# Simple script to check your camera, and make sure that it's set
# up correctly for timelapse shooting.

# FIXME: this should be a function in a utility class.
# Ensure we have all prerequisite binaries installed
for binary in gphoto2; do
    which gphoto2 2> /dev/null > /dev/null
    if [[ "$?" != "0" ]]; then
        $LOGGER "unable to find $binary, exiting."
        exit 2
    fi
done

# Auto-detect camera settings to ensure the fastest gphoto2 startup time.
# FIXME: this should be a function in a utility class.
# FIXME: it would be nice to do this without having to run --auto-detect twice.
CAMERA_MODEL=$(gphoto2 --auto-detect | sed -n '3p' | egrep -o "^(.*\))")
CAMERA_PORT=$(gphoto2 --auto-detect | sed -n '3p' | egrep -o "usb:.*$")


# We need to be in manual focus and manual shutter mode.  If not, 
# explain what's up and then fail.
SHOTMODE=$(gphoto2 --get-config=/main/settings/shootingmode 2>/dev/null | awk '/Current/ {print $2}')
FOCUSMODE=$(gphoto2 --get-config=/main/settings/focusmode 2>/dev/null | awk '/Current/ {print $2}')
ERRORS=0
if [[ "$SHOTMODE" != "M" ]]; then
	echo "ERROR: Camera must be in M (manual) mode, but is in $SHOTMODE mode."
	ERRORS=$(( $ERRORS+1 ))
fi
if [[ "$FOCUSMODE" != "Manual" ]]; then
	echo "ERROR: Lens must be in Manual focus mode, but is in $FOCUSMODE mode."
	ERRORS=$(( $ERRORS+1 ))
fi

exit $ERRORS
