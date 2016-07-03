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

*Instructions to follow.*

## Install

To start the app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix server with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
