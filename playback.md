# Playback of resulting video

Generally speaking, you'll encode to two container formats (MP4 and WebM) in 2 resolutions (2K and 4K) per container.

The codec breakdown looks like of like this:

|| Container Format ||  Resolution  || Video Codec ||
|     WebM          |      4K       |     VP9       |
|     WebM          |      2K       |     VP8       |
|     MP4           |      4K       |     H264      |
|     MP4           |      2K       |     H264      |

# Getting good playback speeds in Linux

There are two popular video playback tools in Linux: `mplayer` ([link](http://mplayerhq.hu/)) and `vlc` ([link](http://videolan.org)).

VLC has extremely wide format support, is cross platform in both CLI and GUI forms, and is well regarded.

Mplayer has some 3rd party GUIs, but generally is a CLI tool. It also has a wide selection of playback formats.

Both players are easy to find in repos like [RPMFusion](http://rpmfusion.org) or other repos that permit patent-encumbered tools.

Each has advantages and tradeoffs, and which one is right depends entirely on your system configuration and needs, and we'll discuss them both below.

### VLC

Advantages: Multi-threaded decoding!

Disadvantage: Doesn't take advantage of [VDPAU](https://en.wikipedia.org/wiki/VDPAU).

### Mplayer

Advantages: Can take advantage of VDPAU, reducing CPU utilization during playback

Disadvantages: single threaded decoding, so you *need* VDPAU support for smooth playback.

### VDPAU

This is an NVidia inspired API for accelerating video playback on Linux/UNIX environments.

It is generally well supported on Intel cards (F/LOSS), NVidia cards (Closed Source only).  Not sure about AMD cards.

It appears to be limited to only MP4/H264 for the time being.  The driver README states that Feature F was supposed to add VP8/VP9 support, but the GTX1060 (3GB) has featureset H (they're additive) and only MP4/H264 appeared to be accelerated via VDPAU in `mplayer`.

## Recommendations

If you have more GPU than CPU to burn and are willing to suffer a slight degration in video quality, go with 4K MP4 and use mplayer and a card/driver with VDPAU support

If you have more CPU than GPU to burn, use VLC and 4K VP9 video.  The quality is (admittedly subjectively) better (less blockiness) and the playback will be slightly smoother.
