# AirQuotes

Using ARKit, measure package dimensions and find the cheapest shipping service.

### Developing
- Dependencies are managed with [CocoaPods](https://cocoapods.org/).
    - Run `sudo gem install cocoapods` from the terminal to install CocoaPods.
    - With CocoaPods installed, run `pod install` from the project directory.
- Development is done in `airquotes.xcworkspace`. Do not use the `.xcproject` file.
- The backend is managed with Firebase. Cloning and running the project should not affect the backend implementation.

### Features
- Tap on the screen to measure. Make two points and the distance will be calculated automatically!
- Click next to continue to the next measurement, and "Get Price" to see live pricing for the item.
- The history view can be accessed via the top left history icon on the homepage.
    - Items are stored in CoreData, and the history icon is drawn using CoreGraphics.

