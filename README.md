# rpi-setup-lcd

## Description
<b>rpi-setup-lcd.sh</b> is a bash script that can install and configure the LCD screen connected to the Raspberry Pi.
It has a colorful command-line interface for faster navigation and can tweak additional display settings.

## Instructions
You must provide the appropriate dt overlay (.dtb) files yourself. Put them in the <code class="language-plaintext highlighter-rouge">./overlays</code> folder. 
Run the script <code class="language-plaintext highlighter-rouge">./rpi-setup-lcd.sh</code> as root and follow the instructions on the screen.

## Features
- Easily install/uninstall screen overlay files
- Set screen rotation

## TODO
- Set font, size, resolution, etc.