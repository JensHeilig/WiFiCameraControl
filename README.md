# WiFiCameraControl
Remotely control your Canon camera with your Smartphone using CHDK, a Toshiba FlashAir card and this software 

This software allows control of a Canon point-and-shoot camera from your Smartphone.

The camera must be equipped with a [Toshiba FlashAir WiFi card](https://www.toshiba.co.jp/p-media/wwsite/flashair.htm) and the [CHDK software](http://chdk.wikia.com/wiki/CHDK).

## Download
The latest version can be downloaded [here](https://github.com/JensHeilig/WiFiCameraControl/releases/latest).
See below for installation instructions.

## Installation
* Get a Toshiba FlashAir SD-card for your camera. Only type W-03 works, do not use the older types W-02 or W-01. 32GB can be had for 30 US-Dollar or Euro.
* [Download](http://chdk.wikia.com/wiki/Downloads#Links_to_the_Different_CHDK_Builds) and install CHDK on the camera SD-card as per [these instructions](http://chdk.wikia.com/wiki/Downloads#Installation) (looks harder than it is).
* Clone or download this repository from Github
* Copy all files from `CHDK` folder to the `CHDK/scripts` folder on the SD-card
* Create new folder `WIFICTRL` in the top-level directory of the SD-card
* Copy all files from `HTML` folder to this folder on the SD-card

## Use
* Switch on your camera (with CHDK loaded)
* Enable WiFi mode of the FlashAir card (see FlashAir instructions)
* Start the CHDK script `WifiCamCtrl.lua`
* Connect to the FlashAir Wifi network with your smartphone (see FlashAir instructions)
* Open this webpage on your smartphone: http://flashair/WiFiCtrl/index.html
* Control the camera from your Smartphone!
