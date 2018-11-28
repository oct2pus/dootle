
~~Simple [Mastodon](https://github.com/tootsuite/mastodon) client designed for elementary OS.~~
Simple Activitypub Client targetting the [Mastodon API](https://docs.joinmastodon.org/), fork from [Tootle](https://github.com/bleakgrey/tootle) to become a GTK+ application suitable for use on the GNOME Desktop Environment.

## Current Goals

The current goal is to improve the front-end design.

### Future Goals
* Provide support for more advanced features from Pleroma while maintaining Mastodon Support.
* Fix images on Pleroma.
* Find a better name than [Dootle](https://www.youtube.com/watch?v=WnRrPqgKBS0).

## Building and Installation

First of all you'll need some dependencies to build and run the app:
* meson
* valac
* libgtk-3-dev
* libsoup2.4-dev
* libjson-glib-dev

Then run these commands to build and install it:

    meson build --prefix=/usr
    cd build
    sudo ninja install
    com.github.oct2pus.dootle
    
## Contributing

If you feel like contributing, you're always welcome to help the project in many ways:
* Reporting any issues
* Suggesting ideas and functionality
* Submitting pull requests
* Consider donating to bleakgrey's [LiberaPay](https://liberapay.com/bleakgrey/) to support the original project. I am not taking donations at this time.

<a href="https://liberapay.com/bleakgrey/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

## Credits
* Tootle by [@bleakgrey](https://github.com/bleakgrey/)
* Medel typeface by Ozan Karakoc
* French translation by [@Larnicone](https://github.com/Larnicone)
* Polish translation by [@m4sk1n](https://github.com/m4sk1n)

## This Project Uses Dumbass Versioning

the Version number goes up when I need a confidence boost.
