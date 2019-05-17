# Using your DSLR to capture HDR images for timelapse photography

By now, you've probably read my [original treatise](dslr-capture.md) on the subject of time lapse video using either a web cam, or a DSLR.

If you haven't, and you're unfamiliar with time lapse in general, I would adivse you to go back and read them:

1. [Time Lapse DSLR](dslr-capture.md)
2. [Time Lapse Webcam](webcam-capture.md)

This guide will give you the basics you need to begin capturing timelapse photos using HDR processes to hopefully make sunsets look better, and other areas involving bright lights and deep shadows.

A photographer named Edu Perez has a [wonderful guide to HDR in Linux](http://photoblog.edu-perez.com/2009/02/hdr-and-linux.html) that I've borrowed heavily from.  It's well worth the read, and his images are great examples of HDR done right.

## Brief overview of HDR

HDR stands for High Dynamic Range.  Dynamic range, in general, is defined as the difference between one end of a spectrum of something and another.

In terms of photography, the dynamic range of an image is the difference between the lightest and darkest pixels.  In music, it's the difference between the quietest and loudest sound.

Your DSLR probably has at least a 10 bits/channel sensor.  The nicest ones are 14 bits/channel.  So that's already a fairly good amount of dynamic range!  After all, that means your sensor is captuing on either the red, green, or blue channels, anywhere between 2^10 (1024) values and 2^14 (16384) values.  Which equates to between 1073741824 to 4398046511104 "color" combinations.

Yet your camera still can't perfectly expose certain scenes the same way the human eyes see them. Even if it could, your monitor definitely can't display them, and that's where HDR comes into play.

Think of being inside a room during the day time, with the lights off, and the blinds open.  Your eye can see the details in the shadows, and the details in the bright outside world.  Yet, try and take a picture of that scene with your camera...

The choice usually comes down to this:

1. Over expose to capture the details of the room and blow out the highlights in the windows
2. Under expose to capture the details of the world outside, and the shadows all become inky black

Try it yourself if you don't believe me.

### HDR Vocabulary

*Tone mapping:* The act of reducing a high dynamic range image into a low dynamic range (i.e.: normal) image.

There are a variety of algorithms that can do this for you, and the results can be anywhere from natural to alien, depending on how the values used.

*Stack:* This is the informal term applied to the series of images, all with different exposures, of the same subject, that will eventually be merged into a single HDR image.

*[EXR](https://en.wikipedia.org/wiki/OpenEXR):* This is the lingua franca of HDR imagery, file format for supporting HDR images.  Developed and released open source by [ILM](https://en.wikipedia.org/wiki/Industrial_Light_%26_Magic).

### When to use HDR

... and more importantly, when *not* to ...

Below is an example of when you might want to use HDR: a bright exterior and dim interior, in the same frame, and you want to capture details of both, as the eye would see it.

![HDR Dark inside, light outside](http://i.imgur.com/XQbqdls.jpg?1 "abandoned building hdr")

As you can see, there's a fair amount of noise in this image.  This is, unfortunately, a byproduct of many tonemapping algorithms.  Controlling that noise is important for natural looking images and video.

### Goals of using HDR

The goal of using HDR is to produce an image that looks like how the eye would actually see it, or at least a close approximation.  For time lapse work, you definitely want to make your images at least realistic, or chances are good, they'll result in huge files (noise doesn't compress well) that look terrible.

### Examples of bad HDR

I'm going to show you some bad examples of how HDR can go horribly wrong.

In the below photo, you can see how badly the image was tone-mapped.  There's halos around the tree and tree line, the strongest indicator that this was HDR.  The sky should never change color like that.  In addition, you can see how the contrasting edges of the trees look slightly blurry, when they should be tack sharp.  That shows me that there was some wind blowing, and that the multiple images may not have been correctly aligned. (I've done worse alignment jobs myself.)  The worst part of this, is that a competent photographer could've exposed this as a single image, and make it look much better without HDR.

![dead tree at sunset (worst hdr)](http://i.imgur.com/LIq0DlH.jpg "worst HDR")

In the next photo, you'll see more noise, and an unnatural tone curve to darken the sky while keeping the mountains viewable.  Again, there's some significant blur in the tree tops, indicating wind and/or poor alignment in post-production.  You also see the glow between the front mountains and back mountains, which the latter must've been more in shadow than the former.  This is definitely the right scene to use HDR, but the execution fell short.

![Mountains of Viet Nam from Laos (bad hdr)](http://i.imgur.com/GUCXuBk.jpg "bad HDR")

In the next photo, you'll see the sky halo (though not as bad as earlier examples), poor focus selection (aperture probably too wide), and poor alignment in post (even though it's been resized, you can still see it, so I can only imagine how bad it looked at full resolution).  More importantly, you can see how the image looks a little too otherworldly, like a planet where the [saturation goes to 11](http://www.imdb.com/title/tt0088258/?ref_=nv_sr_1).

![Symi in Greece (bad hdr)](http://i.imgur.com/mwsQ4Dy.jpg "bad HDR")

### Examples of good HDR

Here's some examples of HDR photography done to achieve a realistic image.

In our first photo, you can see what they were trying to achieve.  They wanted the sunrise sky and the trees to be visible.  There's relatively low noise compared to our earlier examples, and the post production alignment is reasonably good.

![Fiery sunrise (good hdr)](http://i.imgur.com/3FiQwWg.jpg "good HDR")

In the next photo, again, much less noise than previously.  There's only a very small portion of horizon halo effect (you have to look for it!), and most importantly, this image looks _natural_.  There's probably a little too much post-production sharpening for this image, which for still photography is OK.  But it makes time lapse video look a little off, and again, raises resulting file sizes as it doesn't compress well.

![Highway 1 Bay (better hdr)](http://i.imgur.com/5O9RoDx.jpg "better HDR")

In our last image, again, you see good detail in the shadows, plenty of mid tones, and the alignment is pretty much perfect.  This is an image that faithfully reproduces what the human eye might see in this situation.

![Jefferson Memorial (great hdr)](http://img14.imageshack.us/img14/6936/mg136678tonemapped1280x.jpg "great HDR")

## Setting up your camera to take HDR stacks

### Software prerequisites

1. A linux box
2. `gphoto2` package
3. A lot of local storage, or a large CF card!

### Hardware prerequisites

1. A DSLR that `gphoto2` supports burst mode with.

#### WARNING

If you don't have these automated options available to you, you're stuck with a stop-watch and manual release trigger switch for the duration of your shot!

For example, my Canon EOS 300D doesn't offer a whole lot of these options.  The video I made was from manually exposed frames.  I enabled burst mode and exposure bracketing, and then just clicked and held the remote shutter release switch until I heard 3 shots fire off.  Then I let go, wait until 20 total seconds had passed, and repeated the process.  It was mind numbing after just 13 minutes.  I do not recommend doing this unless you have no other choice.  I've considered building a little arduino device that uses an [optoisolator](https://www.sparkfun.com/products/retired/314) circuit to handle the repetitivenss for me, then just decided it's time to buy a new camera.

#### Configuring Burst Mode for your specific camera

1. Check the [gphoto remote docs](http://www.gphoto.org/doc/remote/) for your camera's supported feature list
2. Enumerate your configuration options: `gphoto2  --list-config`
  1. According to [this comment](http://islandinthenet.com/2012/08/hdr-photography-with-raspberry-pi-and-gphoto2/#comment-4017) you're looking for something like `/main/capturesettings/*`
  2. `capturemode` and `burstnumber`, or something like that (the comment was for a Nikon)
  3. use `gphoto2 --set-config "/main/capturesettings/<item>=<setting>"` (the double quotes here are important) to set the parameters.
3. Take a shot with `gphoto2 --capture-image`
4. Check to ensure that it actually bursts!
  1. You may have to set the exposure bracketing manually, if gphoto2 can't set it on the command line for you, but that's not a show-stopper.  Lack of burst basically is.
5. Remember these settings, you'll need to insert them in the intervalometer code.

### Getting a single good stack

Most DSLR's support a technique called exposure [bracketing](https://en.wikipedia.org/wiki/Bracketing).  Effectively, you take multiple shots (in my case, 3) of the same subject on the same camera but with different exposure values (EV).

When I'm shooting by hand, I enable AEB (as Canon calls it on my camera) in the menu, then I switch to multi-drive mode, and depress my shutter release until I hear the shutter clack 3 times.

### Capturing multiple stacks

My camera is old and slow, so writing 3 RAW files to the CF card takes about 20-23 seconds.  So I can't shoot any faster than 1 HDR stack every 30 seconds.  This is an important factor to know about your camera, so be sure to test it out before you go!  The number of images per stack, the resolution you use, the format of images (raw, jpeg, raw+jpeg) and the speed of both your camera and storage media will affect how fast you can work.  Certain things, like winter sunsets, tend to happen quickly.  So if you want a good amount of footage, start early and shoot often. ;)

If your camera's USB interface is still USB 1.1 like my old one, you'll want to make sure your intervalometer doesn't try to download the images over the wire to the controlling laptop.  Instead, leave them on the CF Card.  (Get an 8GB card or higher if you can.)

Beyond that, you'll need a slightly more advanced intervalometer script to capture 3 (or more) bracketed images at a time.

See my [dslr hdr intervalometer](bin/intervalometer-hdr.sh) script.

### Tips and techniques for getting good source images to turn into stacks

1. Use a tripod.  Every time. No exceptions.  Hand-held images will *not* align correctly, no matter how hard you try.
2. Make sure your tripod is secured and steady.  This usually means: sand bags (hanging from the center line if you can) and an even and hard surface (Concrete, asphalt, other roadways, etc.).
3. All bracketed images should be taken in rapid succession to ensure smooth tone mapping and alignment. Ideally all 3 (or more) in under 2 seconds.
4. All of the tips you use when taking tack-sharp regular images still apply:
  1. Choose the f/stop with the sharpest images according to your lens/tests.
  2. Fast shutter.
  3. Lowest ISO you can shoot at while achieving the above.
  4. If you know what you're trying to achieve and it doesn't involve sharp and fast, that's cool too, just be careful during the alignment phase!
5. Use a timer, external shutter release, or USB tether to fire the shutter.
  1. This should be obvious, but I still see people with their finger on the shutter button.  You don't want to manually depress the shutter, it *will* move your camera.
6. Watch the LCD preview on your camera!  You want to make sure that these images you're taking are correctly (and over/under) exposed so that you won't need to fiddle too much in the RAW conversion step.
7. Shoot in manual mode.  Your aperture, shutter, and ISO speed should not vary across shots.  I learned this lesson the hard way shooting a sunset timelapse in Aperture Priority mode. :(
8. Lots of small points of light may not end up looking good, especially if they are the brightest parts of your image.  (Think Las Vegas Strip.)

## Post processing your stacks

There's generally a few processes your still images will have to go through before they are ready for encoding into a timelapse video.

This is the rough outline:

1. "developing" RAW photos into TIFF
2. Aligning the individual bracketed TIFFs
3. Creating the stack from the aligned, bracketed TIFFs.  There's a couple ways to do it:
  1. Tonemapping the real way using HDR software.
  2. Using the `enfuse` binary to give you "corrected" exposures.
4. Merging the stacked, aligned and bracketed sequence of images into a video.

### Software prerequisites

1. A linux box
2. RAW "developing" tool (I use `rawstudio` for interactive work, and `dcraw` for automated work.  Other tools exist but I'm not convering them here.)
3. Image alignment software (I use a binary called `align_image_stack` provided by the package: `hugin-base` in Fedora)
4. Exposure blending software (I use a binary called `enfuse` provided by the package: `enblend` in Fedora)
5. HDR tonemapping tool (I use `luminance-hdr` for interactive work, and pfstools for automated work.)

### Filesystem layout

I assume that you've laid out your directory structure as follows:

```
Subject_Name_Date/
         |_________ raw/       (this is where all your RAW source imagery lives)
         |_________ developed/ (developed TIFFs go here)
         |_________ aligned/   (aligned images go here)
         |_________ enfused/   (enfused stacks go here)
         |_________ hdr/       (HDR EXR stacks go here)
         |_________ ldr/       (tonemapped LDR stacks go here)
         |_________ video/     (final encoded timelapse videos go here)
```
And that your filenames for your RAW shots are numbered sequentially.  If they are not, you should fix that now.


### Developing your raw photos

If you've captured your source images correctly, you won't need to fiddle interactively with the images, and can convert them from RAW to TIFF in an easy batch command:

`ufraw-batch --wb=camera --gamma=0.45 --linearity=0.10 --exposure=0.0 --saturation=1.0 --out-type=tiff --out-path=developed/ --overwrite raw/CRW_????.CRW`

> *WARNING:* Per Edu Perez, --gamma and --linearity options are camera specific. Consult the [unofficial UFRaw FAQ](https://encrypted.pcode.nl/blog/2009/08/23/ufraw-faq/) and look at the first section entitled "the colors are off" to figure out what these values should be.  The TL;DR is that you should shoot some RAW+JPEG calibration pictures at 0EV and then pick values for Gamma and Linearity that make the RAW match the JPEG.

However, if you did things wrong for whatever reason, you'll want to open your stacks in raw studio, and modify them that way.

You can select multiple images at once in the raw studio timeline, then make modifications, and they will all apply to the selected images.  This is good for correcting global problems, such as: under exposure, sharpness, white balance, tint, etc.

Then batch export them as TIFFs, and *be sure to export EXIF data!* (Align and HDR will both be wonky without EXIF data.)

Edu suggests 16 bit TIFFs, but I've had just as good luck with 8 bit TIFFs.  Try both, and let your eyes tell you which looks better!


### Aligning the images

This process, and the next (enfusing) are tricker to automate than the developing and encoding stages.

Your typical for loop is designed to operate on a single iterating variable at a time.  We need to operate on 3.  (or however many images comprise each stack!)

The code for this part looks a little something like this:

```
cd ~/your/project
mkdir aligned
ls -1 developed/*.tif | xargs -P $(nproc) -n3 ~/bin/align_stack.sh

```

What the above means:
1. `mkdir aligned`: make the directory for the aligned images.
2. `ls -1 developed/*.tif`: Output an ordered list of the TIF files
3. `$(nproc)`: Outputs the number of available CPUs (needed for the -P flag to `xargs`)
4. `xargs -P<NUMBER> -n3`: Run the following command using 3 lines of the file list as input, and run up to <NUMBER> such commands at once, until the input is exhausted.
5. `align_stack.sh`: align the 3 images. This wrapper script is reproduced below to help work around a limitation in `align_image_stack` that causes filenames to collide.  This script is reproduced below.

You can use my [align_stack.sh](bin/align_stack.sh) script.

### Enfusing the images

*NOTE:* This is technically "fake" HDR, in that the result is a LDR image.  However, it skips the HDR and tonemapping steps, and often yields a very nice result that looks natural.  It saves time, and looks good, and usually gives you the "good HDR" look.

Much like the align process, the enfuse process takes a little bit of trickery to handle 3 (or more) files at once:

```
cd ~/your/project
mkdir enfused
ls -1 aligned/*.tif | xargs -P $(nproc) -n3 ~/bin/enfuse_stack.sh
```

The steps above look eerily simmilar to the align step, because working with 3 files at once is a PITA. Thankfully, enfuse's output options are much easier to deal with.

You can use my [enfuse_stack.sh](bin/enfuse_stack.sh) script.

### HDR Image Creation (or, when Enfuse isn't good enough)

TBD.  This part is difficult to do by automated script from what I remember.

# What next?

Once you\'ve developed, aligned, enfused, hdr'd, ldr'd and done any other frame by frame tweaks you wanted, now you have to turn those frames into video.  You'll want to continue on with my [resizing and cropping](frame-sizing.md) guide.

What I will tell you is that you should probably try to sequence video from the following sets of frames:

1. the enfused frames
2. the tonemapped LDR frames
3. the 0-EV LDR frames

See which one looks best!
