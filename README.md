# Drawing Assignment

An app for drawing on canvas, it was an home assignment. 

## Requirements

* Xcode 9
* iOS 10+ 
* Swift version: 4

## Device supported

* iPhone
* iPad

## General architecture of the application

### The App Screens

The app include 2 screens:

* Drawing list (DrawingListViewController)
	* Presenting existed drawings in tableView
		* Each drawing include the following details:
			* Thumbnail image of the drawiing
			* Creating date
			* Edit date
	* Allow to create new drawing
	* Selecting existed drawing or creating new one will move the user to the Drawing canvas
* Drawing canvas (DrawingViewController)
	* Canvas that the user can:
		* Paint with some colors
		* Change the line width
		* Using erase
		* Clear the canvas
		* Save the canvas
		* Export image to device camera roll

### Structure

The applicaiton's project is orginize by:

* Model
	* data types
	* data management - for storing the data
* ViewController
* Views
	* Cell
	* UIView - drawing view
* Facade
* Extenstions
	* UIKit extenstion 
* App
	* Strings file
	* centralized alert
	* constants holder

### Data

The data for each drawing is saving in the document directory in the device. It saved in plist file (using persistent storing like Core Data, or other local DB was seems to me a bit too much for this task), holding paths (drawing model). Also it include thumbail image of the drawing. Both of the files have the same file name, the drawing's identifier.

All the drawings info (dates, identifier) saved as list in another plist file. The conenction is by the identifier.

The Path is a model for the user painting (or erasing). Each path can include different properties (color, line's width, painting or erasing, list of points in the path)

### Facade

I use Facade because I want separate between the view controllers to the business logic. This will allow me to change the storing to local db or using remote server, without any need to touch the vcs when I will decide to do it.

### Constants Holder

All the constants are saved in Consts struct, for easy changing and viewing.

### Alerts

Centralize creating failure and success alerts in one place. Without this I will need to repeat on creating duplicate code for creating alerts (like creating ok button for the alert, or parsing error to alert).

### Localize Strings

In my experience it is an easy way to view and change all the strings in the app.

### The Drawing process

The drawing is combine 3 elements:

* DrawingView - UIView that catch touches and allow the user to paint with his touches.
* Path - model that hold properties (width, color, points of the path, erasing or painting) from when the user begin touch to end touch
* DrawingViewController - by pressing buttons, selecting segment value and more, the user's actions are connected to the DrawingView

### Extensions

The extensions are in their own section. They are to general to the app (some of them I used for more than one project in prevoius projects)

## Features I think about but decide not to include

* Adding logger for debuging
* Adding wrapper for localization strings. Maybe adding enum, because I want to write as minimum strings in the code.
* Loading the spinner mechanism instead from the Storyboard to load from a Xib file
* Handling multi touches, The app is working with one tocuh  

## Things I know I need to change

* Moving duplicate code of preventing crash in iPad when using action sheet without popover to the Alert struct.
* Add support to cancel touch in DrawingView.