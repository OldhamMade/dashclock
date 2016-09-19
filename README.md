# DashClock

## Goal

I've been learning Elixir and Elm recently, and wanted a concrete project to help
solidify my understanding of both languages. Since I had a spare Pi and touch-screen
knocking about, I decided to create a digital clock to sit below my TV powered
with Phoenix and Elm.

I've had a basic clock up and running for a while, which you can find at my
[infoclock](https://github.com/OldhamMade/infoclock) project. With the recent
releases of Elixir 1.3, Phoenix 1.2, and Elm 0.17, I decided to rebuilt the
project and add additional information.

## Features

### Clock

The original clock is still available, but updated for Elm 0.17. Some cosmetic
changes were made relating to the date display, but that's all that was done for
this project. The clock runs from the timezone of the Pi itself, so be sure
to set the Pi up as appropriate.

### TFL Status

I'm currently living in London, so wanted passive notification of any problems
with the Tubes and overground. I've not picked any specific lines, preferring
to get a general overview and then use alternate means to plan my route.

### Weather

For the weather, the app obtains the lat/lon of the public IP for the Pi
and uses that location for the weather, displaying the current weather and
an overview for the next 2 days.

## Setup

Burn Raspian to an SD card, and boot once to resize the image. Boot again, and
shell into the pi.

You might get a warning about locales, if you do, run this command:

    $ sudo dpkg-reconfigure locales

and set your locale to `en_US.UTF-8`. When you next connect the error shouldn't show.
We should also update the system:

    $ sudo apt-get update && sudo apt-get upgrade -y

Now that we're up to date, we'll install the base system. Our goal is to set up a
system where:

  1. the system boots and a user is logged in automatically
  2. the webserver starts
  3. the window manager starts
  4. the web browser starts in full screen

For step 1, we'll use `nodm`:

    $ sudo apt-get install nodm -y

Once installed, edit `/etc/default/nodm` and set the following:

    NODM_ENABLED=true
    NODM_USER=pi

Next we need a window manager, a browser, and some way to start all this up:

    $ sudo apt-get install -y matchbox-window-manager uzbl xinit unclutter

Copy the `_pi/uzbl.conf` file to `/home/pi/uzbl.conf`, then copy the
`_pi/_xsession` file to `/home/pi/.xsession` and set the permissions to 700.


### Extras

#### Quieten boot

Edit the `/boot/cmdline.txt` file and make these changes:

  1. Replace `console=tty1` with `console=tty3` to redirect boot messages to the third console.
  2. Add `loglevel=3` to disable non-critical kernel log messages.
  3. Add `vt.global_cursor_default=0` to disable the blinking cursor.
  4. Add `logo.nologo` to disable the small raspberry pi logos

More details can be found [here](http://elinux.org/RPi_cmdline.txt).

#### Add boot image

Copy the `_pi/pisplash.png` file to `/etc/pisplash.png`, and `_pi/asplashscreen`
to `/etc/init.d/asplashscreen`. Then execute the following;

    $ sudo chmod a+x /etc/init.d/asplashscreen
    $ sudo insserv /etc/init.d/asplashscreen

## Install

To start the app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix server with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
