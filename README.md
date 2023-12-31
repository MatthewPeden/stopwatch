# Stopwatch Flutter App

## Overview

This Stopwatch app, developed in Flutter, provides a tool for timing events. It includes features like start/stop, lap recording, and reset functionalities.

## Features

- Start/Stop: Begin or pause the stopwatch
- Lap Recording: Record laps while the stopwatch is running
- Reset: Reset the stopwatch and lap records
- Responsive Design: Optimized for both iOS and Android devices. It can also be ran as a web application.

## Getting Started
### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- iOS or Android Development Environment
  - [iOS Instructions](https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=virtual)
  - [Android Instructions (for macOS)](https://docs.flutter.dev/get-started/install/macos/mobile-android)
  - [Android Instructions (for Windows)](https://docs.flutter.dev/get-started/install/windows/mobile)
- IDE of Your Choosing

### Installing and Running
1. **Switch to Flutter Stable Channel**
    
    First, switch to Flutter's stable channel, upgrade Flutter, and verify the upgrade by running the following commands in your terminal:
    
    `flutter channel stable`

    `flutter upgrade`

    `flutter doctor`
2. **Clone the Repository**

    Next, clone this repository to your local machine using the following command in your terminal:

    `git clone https://github.com/MatthewPeden/stopwatch.git`
3. **Navigate to the Project Directory**

    After cloning the repository, move into the project directory using the following command in your terminal:

    `cd stopwatch`
4. **Fetch Dependencies**

    Fetch the necessary dependencies using the following command in your terminal:

    `flutter pub get`
5. **Run the App**

    After preparing your emulator or physical device, run the following command in your terminal to run the app:

    `flutter run`

    If you want to run it as a web app, install Google Chrome and run the following commands in your terminal:
    
    `flutter config --enable-web`

    `flutter run -d chrome`

## Code Structure

- lib/main.dart: Entry point of the application. Sets up the Flutter app and its theme
- lib/pages/stopwatch.dart: Contains the StopwatchPage class, which has the UI for the stopwatch
- lib/providers/stopwatch.dart: Contains the StopwatchNotifier and StopwatchState classes for managing the state of the stopwatch, as well as stopwatchProvider to access and update the stopwatch state
- lib/providers/timer_interface.dart: Contains timerInterfaceProvider which supplies a TimerInterface instance
- lib/utils/colors.dart: Defines the color scheme for the app
- lib/utils/timer_interface.dart: Contains abstract TimerInterface class for the timer functionality, RealTimer class for actual use in the application, and MockTimer class for testing
- test/unit/: Contains unit tests
- test/widget/: Contains widget tests
- integration_test/: Contains integration tests

## Dependencies

- flutter_riverpod
- mockito
- flutter_test
- integration_test
- test

## Testing

The app includes unit, widget, and integration tests to ensure confidence that it will perform as expected.

1. **Unit Testing**

   To perform unit testing, run the the following command in your terminal:

   `flutter test test/unit`
2. **Widget Testing**

    To perform widget testing, run the following command in your terminal:

    `flutter test test/widget`
3. **Integration Testing**

    To perform integration testing, run the following command in your terminal:

    `flutter test integration_test`