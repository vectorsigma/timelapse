# Capturing timelapse images with a DSLR and Linux

This guide will help you capture timelapse images using your DSLR and a PC running Linux.

For our example, our subject will be the lunar eclipse that happened on 2014/4/15.  However, the techniques and intervalometer code can be re-used in a variety of situations.  The real difference will be in setting up the camera and exposure, so feel free to experiment with whatever you find here.

## What you need to get started

1. A sturdy tripod
2. Steady ground
3. a sand-bag you can hang from the bottom of your tripod for support and stability
4. A Canon EOS series digital SLR (or any other camera [supported by libgphoto2](http://www.gphoto.org/proj/libgphoto2/support.php).)
5. A sufficiently long USB cable to connect your DSLR to your PC
6. A computer of some kind, running Fedora Linux (or any distribution with a modern kernel, libgphoto2, and gphoto2 client installed).
7. A fair amount of free disk space!
   1. The amount depends on the total number of frames to be stored, multiplied by frame size.
   2. In this example, each frame is ~6MB, and we plan to shoot 2 frames per minute, for a total of 4 hours
   3. 6MB * 2F/M * 60M/H * 4H = 2880 MB, or, 720 MB/H

# Some background information

## Understanding your subject

The moon is an unassuming subject.  We see it every night.  Our eyes have a significant amount more dynamic range than your average camera (film or digital) however.

So just shooting pictures of the moon on any given night is a tricky proposition.  You have to limit exposure down to fractions of second to avoid the shine of the moon reducing all of the available contrast, and appearing as just a white dot.

However, when doing so, you also lose the ability to capture the dynamics of the night sky.  Clouds turn black, or worse, fog over your moon.

And just when you think you've gotten it right, you try to photograph an eclipse, and realize that once the umbra is full, your exposure settings are no longer sufficient to resolve the moon.

Oh, and the moon moves in an arc across the sky, faster than you think.  (look at your photos later!)  So you can't just fill the frame with the moon, because 30 seconds later, the moon will be slightly to the right (or left, depending on where you are) of the original shot.  As such, you have to be fairly conscious of the path the moon will take.

Now, I suppose if you had a clock drive and telescope with a DSLR adapter, you could indeed fill the frame with the moon, set your camera to Aperture Priority, enable the clock drive, and then follow the rest of the software only instructions.  But then again, if you have that setup, you don't need this tutorial, do you? :)

## Understanding your camera

TL;DR: Watch this [fantastic video](https://www.youtube.com/watch?v=E7VIWhchVBY) to get an idea of how to set up your camera for timelapse.  There's some fantastic tips in there!

TL;DW:
1. Disable all automatic functions (focus, image stabilization, lcd preview, power off timeout).
2. Shoot manual if at all possible.
3. Shoot raw
4. Protect your highlights
5. Use mirror lock up for long exposure (night)
6. Use live-view and zoom to make sure your focus point is tack-sharp.

Your digital SLR, is capable of producing some very fine photographs.  But, as I said earlier, the dynamic range (difference between brightest and darkest picture it can capture) is significantly smaller than what the human eye can perceive.  Monitors we use to display digital images have the same problem.  As such, your camera is simply unable to cope with the brightness of the moon, and darkness of the sky, at the same time.  You adjust your exposure to favor one or the other.  In our case, we chose to underexpose and lose the sky details to focus on the moon and its contrast.

A DSLR's manual exposure mode is the best way to handle this.  It permits you to focus your camera at a single setting and fixed position.  The importance of this cannot be understated: nothing says "consumer" than auto-iris effects seen in home movies when a lighting change is detected.  Fixing the exposure (shutter, f/stop and ISO sensitivity) over the entire length of the shot will ensure this doesn't happen to you.

### HDR sidebar

High Dynamic Range (HDR) photography attempts to recapture some of that detail by taking multiple images at different exposures in rapid succession (aka: bracketing) and then uses software to merge the images into a single HDR image.  But with that increase in dynamic range, you still need to eventually get to an image regular monitors can display, and this process is called tone mapping.  The end result should be a low dynamic range photo (e.g.: 8bits/channel * 3 channels, RGB) that hopefully is closer to what the human eye remembers seeing when it took the original picture.

There are problems with using HDR techniques with time lapse photography.  The first, is that your subject is moving, subtly.  So you'd need to effectively take 2, maybe 3, shots in *rapid* succession, download them to the computer, all prior to the next interval.  Possible, but dicey.  And that's just trying to capture the data!  The second problem, is that HDR is more art than science.  So you have to open the pictures you take, and see if you can not only get them too composite/map the way you want, but then also automate that entire process. Unless of course, you *like* doing boring work by-hand that should be automatable.  It may very well be able to be automated, I just don't know what the tools are currently capable of.

You also have to understand that you have to have a hard stop of no more than 20 seconds or so for the highest exposure shot, since you start to get star trails much beyond that.

Either way, if you decide to capture HDR, you can always opt to stripe one fo the images in the HDR sequence, and use that conventionally, until you learn to automate the HDR process.  After all, you'll have the data to go back to later, as opposed to trying to regenerate HDR without taking multiple pictures from a higher bit depth sensors.  (The EOS-20D has a 12 bit/channel CCD IIRC)

### RAW vs JPEG sidebar

Most amateur shooters are comfortable with JPEG only.  This will get you 80% of the way to what you need anyway, and if you're just a hobbyist, no big deal.  It also is much easier to work with in terms of stringing images into video, since no conversion work is necessary.  The down side is that you lose quality every step of the way.  Your source images are lossily compressed to start, so if you screw up, you have no recourse in terms of recovering a reasonable amount of data in post processing.  Your resulting final video will also go through a second stage of lossy compression, further reducing quality.

Conversely, RAW Mode will give you more bits to play with in terms of brightening or darkening a photo.  If you're photographing an eclipse, as mentioned above, the extra resolution might be useful to you in terms of being able to bring out details in otherwise dark images.  The price of that however, is that each image must be post-processed into a more standard format (and typically, one with 8 bits per channel, instead of the 12 or more you may get in RAW mode).  Doing this over many frames may prove difficult, even if one setting for conversion can apply globally.  In the case of an eclipse, which has 3 potential ranges (the build up to the full shadow, the full shadow itself, and the ease out of full shadow) that will all need individual consideration in terms of settings, now you need to go through and find the transition points, and effectively morph settings over a small number of frames during the transition to make your video look good.  Or, you know, just apply a single static setting and let the chips fall where they may.

Ultimately, for your first time, JPEG is probably a better choice, and then RAW once you've got a few of these under your belt.

Lastly, a feature not available to RAW mode shooters (at least on older cameras), is in-camera dark-frame noise reduction.  What this will do, is capture two frames: one at your requested exposure settings, and another without lifting the mirror, with the same settings otherwise.  This second frame is called a dark frame, and will be useful to help subtract sensor noise from the original image.  It's important to note that noise reduction will *double your exposure time* (the dark frame has the same exposure time!), so take that into account with your intervalometer settings.

## Understanding time lapse

The whole point of time lapse is to take a long-running/slow-moving event, and compress the time frame to show the viewer something they may otherwise never notice.  The basic process is to take a single frame every so many seconds/minutes/hours/(even days!) depending on the motion velocity of what you're trying to capture.

Celestial objects are prime for this, because in roughly 12 hours of darkness, you can show the Earth rotating and the sky moves in a practically mesmerising fashion.

## Understanding the capture software

gphoto2, the command line client for libgphoto, as we use it here, effectively acts as a remote shutter.  It does not do *anything* more.  What that means, is that your camera must be set up in advance to correctly expose each image.  The computer can't do this for you, it only acts as an intervalometer, using gphoto2 to activate the shutter and transfer the resulting image file.  This is why there's so much information on getting the shot set up correctly to begin with, since if you choose not to, you won't have very good source images to work from.

# Prepations at home before you head to your dark sky site

## Your system

1. Your computer should have a modern enough kernel to have udev+libusb support.
2. Clear off as much disk space as you can.  2 frames per minute is roughly 720MB/hr at 8 megapixel RAW resolution.
3. Install the libgphoto command line client: `yum -y install gphoto2`
4. Install [PowerTop](https://01.org/powertop/): `yum -y install powertop`
5. Install a cron daemon or atd.  (We'll use vixie-cron the rest of the way, but atd is just fine if you choose that route.)
6. Plug in your camera and turn it on.
7. Run `gphoto2 --auto-detect` and record the camera name and USB port strings.
   1. You'll need these as parameters to reduce the lag time between script execution and delivery of the image.
   2. gphoto's autodetect does take a small amount of time, and specifying these in advance will reduce that time.
8. Remember which port you plugged it into, as you'll need to plug it back into that same port once you arrive on site!

### Reducing power draw

1. disable any wireless networking hardware.  Bluetooth, wifi, and GSM/CMDA/WiMax.
   1. using the rfkill switch is insufficient in some cases, shut off the hardware in the system BIOS/UEFI
2. If you're using a laptop, ensure that the system doesn't sleep when the lid is closed.
3. Use an SSD if you can.  Doesn't need to be large, 32GB should be sufficient (~5GB for base OS, the rest for pictures)
4. Ensure your screen is set to minimum brightness.
5. Tune using `powertop --auto-tune`
6. Once done, suspend your laptop
7. Now resume it and ensure it comes up OK.
8. Now make sure you can trigger your camera via USB with it.
   1. If any tests don't work, it's time to investigate which powertop tunable prevented it.
   2. Reboot, and enable one tunable at a time from the default configuration.
   3. Now perform a suspend -> wake -> plug -> capture cycle until you've identified which one failed.
9. Disable LCD preview on your DSLR.

## Intervalometer code

Really, this code should be pretty simple.  Here's a short implementation in bash.  The basic premise is:

Calculate how many frames you need to take, and how long to sleep between frames. Then pass those photos to gphoto2 and let it's built-in timer do the work for you.

See my [intervalometer dslr](bin/intervalometer-dslr.sh) script.

# On-site preparations

## Location

Unless you're either naive, stupid, or willing to risk losing your gear, you'll want to be near your equipment.  Home is the easiest place to start, since you have some physical security and mains power available.  That's what we did to get the basics down for this project.

### Power sidebar

Should you decide to be away from home, the most important thing will be strong batteries and long life.  Your camera's batteries are likely to last longer than your computer.  In our case, our single-battery EOS-20D was snapping away for 4 hours (2 shots per minute) and still had a nearly full battery.  Longer series of exposures will benefit from a battery grip with 2 batteries.  Laptops with 9 cells (and/or two batteries!) are ideal for capture.  Use a power inverter with your car if you must, but beware drawing your car battery below 80% charge. [See here](https://www.lifewire.com/car-batteries-are-made-to-die-534765) for why.

### Environmental effects sidebar

If it's cold out, you may want to cover your camera (and laptop) with a small dish cloth or something similar, to help mop up any condensation.  Additionally, your lens may suffer from condensation.  There are a variety of ways of solving this particular problem.  They range from grease like substances to oily sprays, etc.  While I have no opinion or recommendation on which of these to use, I will offer than you're better off first mounting an appropriately sized UV filter on your lens first.  You can feel free to use the least expensive one, since UV light during the evening isn't neccessarily going to be a problem.  In the day time, using a high quality UV filter is advised.

Should you be shooting through window glass, or similar obstructions, a circular polarizing filter is advised.  In addition, it is advised to frame some kind of light block around the aperture of your lens to block any possible inside light sources from causing any glare.  A circular (not bayonet!) lens hood will suffice, as long as the hood is pressed directly against the glass with no light leaks.  (probably not possible unless you're shooting through a sky-light for this task.)

## Camera

1. Set up your sturdy tripod, including any extra weights.
2. Mount your camera the tripod.
3. Make sure your camera is correctly naming images using increasing sequence numbers.
   1. This is the default on Canon cameras, if you haven't messed with this setting.
4. Ensure that RAW or JPEG mode is enabled in your camera's settings.
   1. DON'T USE RAW+JPEG.
   2. RAW+JPEG will end up leaving the JPEG's on the CF card, while downloading the RAW's, leaving you with disk space issues on the CF card itself!
5. Zoom all the way in on the moon.
6. Adjust your exposure such that the moon's contrast is preserved despite its brightness.
   1. Start in aperture value mode
   2. Set your ISO sensitivity somewhere low, starting around say 400.
   3. Set the aperture for the widest your lens will go
   4. Expose, note the shutter speed and f/stop
   5. Assuming it looks good, these are your settings.
      1. If things look too bright, adjust your ISO sensitivity downward.
      2. Still too bright?  Stop-down, one stop at a time.
   6. Ideally, you want your exposure time to be relatively short, between 1/500 and 1/10 second.
7. Once dialed in, to save battery power, disable LCD preview
8. Zoom out to as wide an angle as you can
9. Take a snap shot and zoom in on the LCD to ensure you've got tack-sharp focus on the moon.
10. Ensure you have a good knowledge of the moon's arc and aim your camera accordingly.
11. Connect the USB cable from the camera to the system.

# Gathering the images

Once you're on-site and your camera rig is set up, it's time to either auto-time or otherwise execute the intervalometer script to gather your source images.

## Executing the intervalometer

The nice thing about the script above, is that you can either execute it directly when you're ready to start, or you can execute it at a specific time using cron or at.

See crontab(5) for how to properly set up your user-level crontab entry to execute a script at a specific time, but the gist is that it will look something like this:
```0 0 * * *	/home/you/bin/intervalometer.sh```

# Post processing your RAW images

*note:* JPEG users can probably skip this section, I hope you set your camera up well, because fixing your exposure now is a right PITA.

## Software you'll need

At this point, you're going to start processing RAW images.  For this, you'll need some additional interactive tools to help you get your images right.

There are a variety of RAW workflow tools available to you in Fedora specifically, and GNU Linux in general.  A non-exhaustive list here:

* [darktable](https://www.darktable.org/)
* [rawtherapee](http://www.rawtherapee.com/)
* [ufraw](http://ufraw.sourceforge.net) (Can be used inside of gimp and cinepaint as a plugin unlike the others on this list)

I use `darktable` for my interactive workflow.  It's got a lot of power and processing available to you.  It supports OpenCL acceleration, which is handy when constantly tweaking controls on high megapixel images.

Darktable does a few things _very right_, and the first most useful thing, is its copy/paste support.  The second, is its batch export capability.  Unfortunately, multi-threading is not it's strong suit, so be aware of that.

## Dark Table (Interactive part)

1. Open darktable
2. Import your directory of images.
   1. See [basic workflow here](https://www.darktable.org/usermanual/en/darktable_basic_workflow.html) for how-to.
3. Glance over all of your images, noting:
   1. Did you get the imagery you needed?
   2. Where are the transition points for full shadow, and not?
4. Adjust the first image of your set so it looks good in the darkroom pane of Darktable.
5. Follow [these instructions](https://photo.stackexchange.com/questions/39055/how-to-batch-edit-a-collection-of-raw-files-in-darktable) to copy the history stack and paste it across all your other images in lighttable view.
6. Follow [these instructions](https://www.darktable.org/usermanual/en/exporting_images.html) to export the batch of images.
   1. Choose an output directory (I use a separate directory from my input photos)
   2. Choose the PNG format (mencoder won't accept TIFF as an input file format)
   3. Change the output filename format to just %f, you shouldn't need an additional serial increment on top of what your camera gives you.
   4. Change your output image size if you wish.

Once you've exported all of your frames to their 8bit/channel PNG format, in their native resolution, you still need to correctly crop and resize each frame.  See my guide on [resizing and cropping](frame-sizing.md) for the next step.
