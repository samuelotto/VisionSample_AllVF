# VisionSample_AllVF

## Table of Contents
* [Introduction](#introduction)
* [Features](#features)
* [Requirements](#requirements)
* [Revision History](#revision-history)
* [Detailed information about the project](#detailed-information-about-the-project)

# Introduction
A simple sample for [B&amp;R Machine Vision](https://www.br-automation.com/de-de/produkte/vision-systeme/) with all Vision Functions.

This sample is used in the [Training: Einführung Integrated Machine Vision [SEM1610.3]](https://www.br-automation.com/de-de/academy/seminare-in-deutschland/alle-laender/seminare/training-einfuehrung-integrated-machine-vision-sem16103/) in Germany, Friedberg. It can also be used as a simple test and basic project.

As all vision functions are included, it can easily be used to test the vision functions in the [Offline-HMI](https://help.br-automation.com/#/de/4/machine_vision%2Fmapp_vision%2Fprogramming%2Fhmi_thematisch%2Foffline_hmi%2Foffline_hmi_-_allgemein.html).

**Note**: The included tasks serve only as a code example. It is recommended that you follow and understand the content and expand or adapt it if necessary.

**Note**: There is a sample with much more extended functions available: [mappVision-Demo/basic](https://github.com/br-automation-com/mappVision-Demo/blob/basic)

# Features
* Simple Vision Applications for every available
Vision Function
* Sample task for triggering the [Camera](https://www.br-automation.com/de-de/produkte/vision-systeme/smart-camera/)
	* Including the use of [Smart Light](https://www.br-automation.com/de-de/produkte/vision-systeme/smart-light/)
* Sample task for showing the image on a mappView visualization
	* Including the download of the image e.g. as jpg or svg file
* Sample task for downloading and saving the raw bmp-image.  This can be necessary, if the mappVision HMI cannot be used, e.g. because of the object is moving and the trigger is fired via application or mappMotion.


## Included Vision Functions
* Pixel Counter
* CodeReader
* OCR
* Deep OCR
* Blob
* Subpixel Blob
* Matching
* Clutter Matching
* Simple Matching
* Measurement
* Alignment (CodeReader to DeepOCR and Matching)
* AllVFs (one Vision Application with all Vision Functions)

# Requirements
Should also work with newer and some older versions
* Automation Studio 4.12
* Automation Runtime M4.93
* mappVision 5.27 (at least 5.26)
* mappView 5.24

# Revision History
## V1.00.0
First version

## V1.01.0
Added task Vi_SaveBmp

# Detailed information about the project
## General configuration
All settings are done as described in the mappVision Getting Started: [Automation Help - mappVision - Getting Started](https://help.br-automation.com/#/en/4/machine_vision%2Fmapp_vision%2Fgetting_started%2Fgetting_started.html)

## Task Vi_Main
This task can be used to trigger a camera.

The variable **CmdTriggerImage** activates the trigger

When the Camera is used with Smart Light it is a requirement that the trigger is activated with NetTime. Because of the included Smart Lights, this task uses NetTime. Without Smart Lights it is possible to trigger without NetTime.

**Note**: To use NetTime, the Trigger needs to be set to "NetTime" in the Vision Application

For the handling with the camera see the chart in the help: [Automation Help](https://help.br-automation.com/#/en/4/machine_vision%2Fmapp_vision%2Fprogramming%2Fvfs%2Fhardware_funktion_-_standardkonfiguration_kamera.html)

## Task Vi_Image

This task has two features:
* Load the image from the camera and show it in mappView
* Save the image on the PLC

The variables **CmdShowImageMappView** and **CmdSaveFile** start the functions.

## Task Vi_SaveBmp
This sample-task loads the image from a camera and saves it as bmp file. This can be necessary, if the mappVision HMI cannot be used, e.g. because of the object is moving and the trigger is fired via application or mappMotion.

The variable **CmdSaveRawBmpFile** starts the function.

## Vision Functions

* All Vision Applications are available:
	* Separate in one file
	* Together in one big file

There are no settings (e.g. ROI or Models) saved in the vision functions.
With this "empty" functions it is easily possible to test everything in the Offline-HMI.

All Image-Acquisition parameters are set to default-values and need to be adapted to your camera. E.g. Image-Size, Trigger-source (Delay or NetTime), ... Only the VACR uses NetTime, because of it is used as the sample for the Smart Light


