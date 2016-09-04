#!/bin/bash
#
# HDR intervalometer script.  Only writes to CF, not local disk.
# 
# Modify only these variables. The rest is done for you.
# Execute either directly or via cron/at

FRAMES_PER_MINUTE=2
HOURS_TO_RECORD=1

## Modify nothing below here ##
SLEEP_INTERVAL=$((60/${FRAMES_PER_MINUTE}))
TOTAL_FRAMES=$(( ${FRAMES_PER_MINUTE} * 60 * ${HOURS_TO_RECORD} ))
LOGGER="logger -s"

# Ensure we have all prerequisite binaries installed
for binary in gphoto2; do
    which gphoto2 2> /dev/null > /dev/null
    if [[ "$?" != "0" ]]; then
        $LOGGER "unable to find $binary, exiting."
        exit 2
    fi
done

# Auto-detect camera settings to ensure the fastest gphoto2 startup time.
# FIXME: it would be nice to do this without having to run --auto-detect twice.
CAMERA_MODEL=$(gphoto2 --auto-detect | sed -n '3p' | egrep -o "^(.*\))")
CAMERA_PORT=$(gphoto2 --auto-detect | sed -n '3p' | egrep -o "usb:.*$")
GPHOTO="gphoto --camera '${CAMERA_MODEL}' --port '${CAMERA_PORT}'"

# Detect if camera is capable of using burst-mode, trigger mode, or
# neither.  Default to burst mode if it's supported, falling back to
# trigger mode, and then finally, multiple command support (slow).

BURST=0
TRIGGER=0

$GPHOTO --list-config 2> /dev/null | grep -q burst
if [[ "$?" != "0" ]]; then
	$LOGGER "no burst mode support."
else
	BURST=1
fi

$GPHOTO --trigger-capture 2> /dev/null > /dev/null
if [[ "$?" != "0" ]]; then
	$LOGGER "no --trigger-capture support."
else
	TRIGGER=1
fi

MODE=0
if [[ ${BURST} == "1" ]]; then
	MODE=2
elif [[ ${TRIGGER} == "1" ]]; then
	MODE=1
else
	MODE=0
fi

# Capture stacks using gphoto2's multiple command capability for DSLR's that don't
# support either: --trigger-capture (which doesn't wait for a picture write event!)
# or
$LOGGER "Capturing ${TOTAL_FRAMES} 3-frame stacks, sleeping every ${SLEEP_INTERVAL} seconds."
if [[ "$MODE" == "0" ]]; then
	for ((i=0; i < $total_frames; i++)); do
		$gphoto --capture-image --capture-image --capture-image
		sleep ${SLEEP_INTERVAL}
	done
elif [[ "$MODE" == "1" ]]; then
	# WARNING: This is untested code, since my camera is full of fail and cannot support trigger!
	# It's here mostly as a stub for hopeful testing.
	for ((i=0; i < $total_frames; i++)); do
		$gphoto --trigger-capture --trigger-capture --trigger-capture
		sleep ${SLEEP_INTERVAL}
	done
elif [[ "$MODE" == "2" ]]; then
	# WARNING: This is untested code, since my camera is full of fail and cannot support burst mode!
	# It's here mostly as a stub for hopeful testing.
	$GPHOTO --set-config="/main/capturesettings/capturemode=1" --set-config="/main/capturesettings/burstnumber=3"--frames ${TOTAL_FRAMES} --interval ${SLEEP_INTERVAL} "$CAPTURE_OPT"
fi
