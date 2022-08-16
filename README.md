# screening_test

This Flutter application is built according to the requirements of the Zumstart Screening Test, which is to implement a simple UI version from a Youtube Video demo.

## Demo Video
This demo is captured on iOS Simulator iOS 15.5, iPhone SE (3rd Generation).
![](/demo.gif)



## How to run this application

Prerequisite: Install Flutter SDK, Flutter plugin for IDE and an Android/iOS simulator.Specific guides can be found from this [Get started guide from the official Flutter Documentation website](https://docs.flutter.dev/get-started/install).

1. Clone this repo from GitHub.
2. Open the project in your preferred IDE (e.g. Android Studio, VS Code).
3. Open your terminal (or command line) in the directory of this project and run `flutter doctor` to ensure everything is setup correctly.
```
flutter doctor
```
4. Run `flutter pub get` to get all the dependencies used.
```
flutter pub get
```
5. Open the Android/iOS emulator and run the app through your IDE of choice.

## Required dependencies
- [rect_getter](https://pub.dev/packages/rect_getter) This library allows creating a global key for every rendered widget. It is used to provide specific index for every section, which is compatible to implement for tab bar indexes.
- [scroll-to-index](https://pub.dev/packages/scroll_to_index) This library offer `AutoScrollController` to replace normal `ScrollController`. It has a `scrollToIndex` function, which is used for scroll to the section when tapping on tab bar.
- [intl](https://pub.dev/packages/intl) This library is used to format the price with commas separating the thousands.

## Notes
- I have never written unit testing in Flutter, but I will search for online tutorials and courses on Udemy or any learning platform to learn how to do it.
- I have researched a great deal and gained a lot more insights of about Flutter to implement the requirements, and had included all the sources that I used to implement this UI.
- Old demo video:  
![](https://github.com/danh1215/FlutterScreeningTest/blob/try_implement_customscrollview/readme_gif/demo.gif)

## Credits and references used

- [To understand more about Flutter Slivers](https://www.raywenderlich.com/19539821-slivers-in-flutter-getting-started)
- [To make collapsable AppBar](https://youtu.be/s_3ak-4u43E)
- [To scroll to the correct position when tap on tab bar](https://stackoverflow.com/a/61709995)
- [To reference the implementation of highlighting tab bar when scrolling](https://pub.dev/packages/vertical_scrollable_tabview)

