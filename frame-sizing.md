# Resizing frames prior to encoding

The previous document showed you how to set up frame capture for a specific
device: [DSLR](dslr-capture.md), [webcam](webcam-capture.md), [etc.](dslr-hdr-capture.md),

In this document, we cover how to take the raw frames from your imaging device,
and crop/resize them into something suitable for encoding into a proper
timelapse video.

## Software used

* [Gimp](https://www.gimp.org/)
* [ImageMagick](https://imagemagick.org)
* [xargs](https://www.gnu.org/software/findutils/)

## Resolution and codec sidebar

You may want to produce a couple of different streams from this timelapse series.  It is important that you make each differently sized stream from the original source material.  Don't just down-rez the highest resolution copy of your final output, you'll just add generation loss to an already lossy process.  Let `imagemagick`, `xargs` and your CPU cores do the work for you.

Also, stick to standard sizes, it should make encoding ever so slightly more efficient:

* 4096 x 2160, aka: [DCI](https://en.wikipedia.org/wiki/Digital_Cinema_Initiatives) [4K](https://en.wikipedia.org/wiki/4K_resolution#Resolutions)
* 3840 x 2160, aka: [2160p](https://en.wikipedia.org/wiki/4K_resolution#Ultra_HD), aka: Ultra HD (UHD), ~8.2 MegaPixel
* 2048 x 1080, aka: [DCI](https://en.wikipedia.org/wiki/Digital_Cinema_Initiatives) [2K](https://en.wikipedia.org/wiki/2K_resolution)
* 1920 x 1080, aka: [1080p](https://en.wikipedia.org/wiki/1080p), aka Full HD (FHD), ~2.2 MegaPixel
* 720 x 480, aka: 720p, aka HD

Use your best judgement here.  Producing DCI resolution 2K and 4K frames when the destination is likely someone's TV is probably not necessary.  By the same token, don't only encode ultra HD and assume everyone else can down-sample to their native resolution.  Most systems made prior to 2016 do not have [HEVC](https://en.wikipedia.org/wiki/High_Efficiency_Video_Coding) and will have a really tough time playing back your videos downsampled.

I would recommend always encoding a 720p stream, and then choose either DCI resolutions or TV resolutions for the remaining 2 higher resolutions.  It's unlikely you'll need all 5.

## Determining how to crop and resize your frames

Prior to encoding, you will want to have resized and cropped your original frames to their appropriate resolution, as determined above.

How you do this is fairly simple.  For example, we'll be working with the original image size of 3080x2048, and 1080p resolution for the cropped and resized frames.

You should do this same procedure for each size you intend to encode for:

1. Determine the final frame size
  1. gimp will tell you this when you first open `image -> scale image`
2. Determine the input frame size.
  2. See the above sidebar and pick your sizes.
3. Reduce the size of the image in such a way that you maintain the *original* aspect ratio
   1. Open the original image in Gimp
   2. Choose Image -> Scale Image
   3. Change the width to the width of the final frame size (1920 in our example)
   4. Make note of the calculated height. (1280 in our example)
   5. Resize the image.
4. The height will be greater than that of the final frame, so you'll need to decide how much of the original frame to crop, and which direction.
   1. In Gimp, choose Image -> Set Image Canvas Size
   2. Change the height to the final frame size height
   3. Subtract the final size from the original size, and note that value. (200 in our example)
   4. Play around with the crop frame in Gimp until you have a satisfactory image, and note the Y offset. (-105 in our example)

## Batch resizing your frames

1. cd into the directory with the original resolution frames
2. make a directory called resized2k (or something to that effect that includes the output resolution)
3. `ls -1 *.png | xargs -n1 -P $(grep ^processor /proc/cpuinfo | wc -l) -iblah convert blah -resize 1920x1280 -gravity Center -crop 1920x1080+0-105 +repage resized2k/blah`
   1. where: `ls -1 *.png` creates a list of files, one line per file.
   2. where: `grep ^processor /proc/cpuinfo | wc -l` will tell you how many processors you have on your system available to resize images.
   3. where: `xargs -n1 -P4 -iblah` will run one convert command per file, 4 jobs at a time. (Assuming the putput of the previous script was 4)
   4. where: `convert blah -resize 1920x1280 -gravity Center -crop 1920x1080+0+0 +repage resized2k/blah` will resize the original frame down, and crop the excess, outputting it in another directory, so as not to overwrite the original.
      1. The 1920x1280 resolution comes from the resizing part in Gimp, but keeping the aspect ratio.
	  2. The 1920x1080+0-105 crop comes from the final frame size, with the -105 offset from our crop exercise.

## What's next?

Now that you've got folders with frames sized for each resolution you care about, you can go about [encoding them into video](video-encoding.md).
