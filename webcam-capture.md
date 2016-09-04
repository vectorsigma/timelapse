# Capturing timelapse images with a basic web cam and Linux

## Background

This is a less advanced version of my DSLR timelapse howto.  You should read that howto first.

The basics of the process are still the same, but the techniques used to capture the images change a fair bit.

## Prerequisites

### hardware

* a Linux box
* a web cam that\'s supported by V4L2 (In our example, it\'s a Logitech C310)

### Required software

* [uvcdynctrl](https://sourceforge.net/projects/libwebcam/) to help you determine facts about your camera.
* [fswebcam](https://www.sanslogic.co.uk/fswebcam/) to actually capure the images.
* [Cheese](https://wiki.gnome.org/Apps/Cheese) for visually orienting your webcam.
* `pbzip2` and `tar` for archiving the raw frames.
  * 3.2GB of 720p PNG compressed down to 430MB.
* my webcam intervalometer script

## Prepping the webcam setup

1. You need to ensure any indicator LED\'s are covered in black tape.  I learned this the hard way.
2. Any potentials for glare need to be addressed.
  1. Cover any areas between the camera and any windows
  2. Ideally, the camera should be inside of a black matte box, so nothing behind or on top of the camera can reflect.

## Capturing images

1. Aim the camera
  1. Use `cheese` to orient the web cam and frame your subject.
2. Set the intervalometer script to run via cron/at.
3. Wait...

## Encoding the video
<!-- `mencoder mf://*.png -mf fps=30:type=png -oac copy -ovc x264 -x264encopts threads=0 -idx -o timelapse.avi` -->

## Post processing

1. Not much to do.  Just bzip2 the raw frames.  3.2GB of PNG compressed down to 430MB tar.bz2.
