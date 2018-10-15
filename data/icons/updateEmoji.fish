#!/usr/bin/fish
#GNU All-Permissive License
#Copying and distribution of this file, with or without modification,
#are permitted in any medium without royalty provided the copyright
#notice and this notice are preserved.  This file is offered as-is,
#without any warranty.

# This is a Simple fish script to create a bunch of size variants for svg files, requires rsvg-convert and fish, fish is provided in the 'fish' package on Debian GNU/Linux and rsvg-convert is provided under the 'librsvg2-dev' package in Debian GNU/Linux

# creates a PNG file for every file in that direction
# argv[1] is the height and width, argv[2] is the directory name
function createPng
  for svgName in (ls svg/*.svg)
    # first sed removes directory, second sed removes file extension
    # this could probably be writen better
    set pngName (echo {$svgName} | sed 's,^[^/]*/,,' | sed 's/\.[^.]*$//')
    rsvg-convert -w {$argv[1]} -h {$argv[1]} {$svgName} > {$argv[1]}/{$pngName}.png
  end
end

# checks if dir exists, if not create it
function newDir
  if not test -d {$argv}
    mkdir {$argv}
  end
end

# the program 'loop'
# theres probably a more beautiful way to write this
newDir 16
createPng 16
newDir 24
createPng 24
newDir 32
createPng 32
newDir 48
createPng 48
newDir 64
createPng 64
newDir 128
createPng 128

