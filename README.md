# Decent Car - Car Listing
A car listing application that allows users to view a list of cars and their details, compare cars and make phone calls to car owners.

## Features
* A car list is displayed on the main screen
* Scroll view to view all car images with page numbering
* Long press on a car owner's phone number in the table view to make a call through a menu
* Compare button in the table view trailing swipe action to compare cars
* Comparison screen to compare car features side by side by swiping to the right on a car

## Technical details
* Built using the MVVM architecture
* Tests are written and can be run using cmd + U
* View controllers are written without storyboards, and a xib file is created for the table view cell with programmatic layout
* SnapKit is used for programmatic layout adjustments
* CocoaPods is the chosen dependency manager
* The fields for make, model, modelline, color, fuel, seller type and seller city were made into enums
* The images are cached based on their URLs and will not be downloaded again unless the URL changes. The application will refresh the URLs every time it is opened to update any changing URLs.

## Created with
* Xcode 14
* CocoaPods 1.11.3


https://user-images.githubusercontent.com/9871990/216124025-1a98adb8-ec6b-447e-ab6b-ea2834eb1824.MP4

![image](https://user-images.githubusercontent.com/9871990/216124352-4027e4b3-cdec-4676-b780-9a4e3b69bec4.png)

![IMG_2039](https://user-images.githubusercontent.com/9871990/216124169-2016c0f6-b181-46ba-8cd4-e86022c472bc.png)
