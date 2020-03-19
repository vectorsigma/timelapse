# Notes on video encoding for HTML5

Since video encoding is the second most important part of timelapse (initial frame capture
being first), I thought I'd write a few notes to handle the encoding process.

Previously, you were reading up on [resizing and cropping](frame-sizing.md) your frames.

*n.b.:* if you just upload to youtube, you can stop reading now, this isn't for you.

*note:* Most X video acceleration drivers won't process over 2048x2048 frame sizes, so acceleration will be disabled.  `mplayer` may not play at all, while `vlc` will play it back nicely, but using a lot of CPU time.

## Software

Since I focus on using free software, I won't describe Squeeze or other proprietary
tools.

The TL;DR is: [Use FFMPEG](http://ffmpeg.org).  It's easier to use for novice CLI
users than [mencoder](http://mplayerhq.hu), and supports the MP4 container format.
As an ancilliary tool, the [gpac](http://gpac.sourceforge.net/) utilities are also
extremely handy to have around when messing with AAC/M4A audio.

## What's your destination?

If you're just looking for desktop playback, the bits I wrote about using x264 in my
previous documents will do just fine.

However, if you want to author for the web, things get a little more interesting.

The most important thing to know: Flash *is* going away.  HTML5 is very capable now,
and more importantly, it [simplifies](http://www.w3schools.com/HTML/html5_video.asp) the necessary bits to actually show video on
your own web site.  So don't worry about encoding a bunch of 240p and 360p shit for
stuff that was released 10 years ago and requires h.263 (aka FLV flash video),
unless your content is aimed at folks still using feature phones or extremely limited
mobile devices.

## HTML5 video in a nutshell

There are 3 formats you need to know about:

1. MPEG4 [part 10](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC)
2. [WebM](http://www.webmproject.org/tools/)
3. [Theora](https://www.theora.org/)

The other thing you need to know, is that your video needs to be encoded into *all 3*
formats.  H.264 gets you most of the way, but WebM and Theora cover the open source
users (FireFox, Konqueror, etc.).  It's trivial to encode to all 3 format, and disk
space is cheap, so there's no excuse.

The next thing you need to know, is what the basic HTML looks like to instantiate
a video player control:

```
<video width="1280" height="720" controls>
        <source src="timelapse2k.ogg" type="video/ogg">
        <source src="timelapse2k.web" type="video/webm">
        <source src="timelapse2k.mp4" type="video/h264">
       Your browser doesn't support HTML5 Video. Sucks to be you.
</video>
```

*note:* Order doesn't seem to matter.  Firefox, at least, has a preference for WebM
over Theora, despite ordering.

*note:* The width and height of the <video> tag are purely size of the element on
the page and have nothing to do with the video itself.

Theora is free software, and patent/license free.  It looks good too, so naturally
that's my preference.  WebM is second, because Google bought and paid for VP8
(includng patents, IIRC) so it's a good second choice.  MP4 however, is laden
with [patents](https://en.wikipedia.org/wiki/MPEG-4#Licensing) and other nonsense.  While there's Free Software that can work with
it, you may be taking your chances from a support perspective.  That's why you
use all 3. :)

## Encoding

This tutorial assumes you've already at least cropped and resized your frames
into a sequence of PNGs, you're ready to encode them into a final video, and
you've `cd`'d into that directory.

If not, see my previous instructions on resizing, cropping, video file resolutions,
etc., and then come back here.

I cribbed some encoding settings from [this answer](https://superuser.com/questions/424015/what-bunch-of-ffmpeg-scripts-do-i-need-to-get-html5-compatible-video-for-everyb) specifically for WebM encoding,
which appears to be difficult ot parse and get to look right just by twiddling
switches on your own.

Also, found this [great Q&A](https://superuser.com/questions/915818/ffmpeg-wants-to-overwrite-existing-images) for how to get
FFMPEG to do what mencoder could do well already.  So now we don't incur any
generaton loss!

*note:* the key parameter here is the `-pattern_type glob`, and the *single-quoted* path
to the frames.  Otherwise, `ffpmeg` tries to overwrite every frame during the encoding
process, and it asks you to overwrite, each. damn. time.

*note:* These settings are "quality" based, not bitrate based, so these command lines will
also work with your 4K frames as well as your 2k frames.  Rejoice!  If you end up using
constant bitrates though, you'll want to double the 2K bitrate to get an approximation of
what you'll need for the 4K bitrates.

### Ogg Theora

*n.b.:* Use TIFF output if you care about Theora encoding.  TIFF inputs work fine, but PNG inputs
result in horridly blocky and artifacted nonsense.

*n.b.:* The Theora encoder doesn't seem to benefit from the `-threads` option, whereas the rest do.

`ffmpeg -pattern_type glob -i 'resized2k/*.tif' -vcodec libtheora -threads $(nproc) -q:v 7 -framerate 30 timelapse2k.ogg`

### WebM/VP8

`ffmpeg -pattern_type glob -i 'resized2k/*.png' -c:v libvpx -threads $(nproc) -qmax 42 -qmin 10 -f webm -framerate 30 timelapse2k.webm`

### H.264 MP4

`ffmpeg -pattern_type glob -i 'resized2k/*.png' -c:v libx264 -threads $(nproc) -crf 25 -framerate 30 timelapse2k.mp4`

### H.264 AVI

This is in case you, for some reason, prefer the [AVI](https://en.wikipedia.org/wiki/Audio_Video_Interleave) container and `mencoder` over `ffmpeg`:

`mencoder mf://resized2k/*.png -mf fps=30:type=png -oac copy -ovc x264 -x264encopts threads=0 -idx -o timelapse.avi`

where:
* `mf://*.png` tells mencoder to use the multiple file driver on all PNG's in $PWD
* `-mf fps=30:type=png` tells mencoder we're using PNG files (PPM not natively supported, boo) @ 30fps.
* `-oac copy` tells mencoder not to bother with any audio stuff (there isn't any anyway)
* `-ovc x264` tells mencoder to use the lavc codecs
* `-x264encopts threads=0` Enable automatic multi-threading
* `-idx` tells mencoder to write indexing into the AVI for seeking
* `-o timelapse.avi` tells mencoder to write the resulting video to timelapse.avi
