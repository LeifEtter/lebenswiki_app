# Extended For Mobile App

The Lebenswiki Frontend, a Mobile App developed with the Flutter SDK, serves as a platform for users to create and view interactive Articles. It is part of [Lebenswiki](https://www.lebenswiki.com/), a project that strives to provide youths and young adults with a centralized repository for knowledge and interactive ways of learning.
This documentation gives an overview of the App's Layers and their Interactions. It assumes basic knowledge of [Flutter](https://docs.flutter.dev/#new-to-flutter), Application Development, [OOP](https://www.educative.io/blog/object-oriented-programming) and [Domain-Driven-Design](https://en.wikipedia.org/wiki/Domain-driven_design).

## Prerequisites

- Flutter Installed
- Either:
   - Android Studio with an Android Simulator
   - XCode with an iOS Simulator
   - Real Android or iOS Device connected and with Debugging enabled
- VSCode oder Android Studio (needed for debugging)

## Installation

Retrieve packages by running:

```dart
flutter pub get
```

Create a .env file in the projects root directory and ad this line:

```yaml
API_URL=https://api.lebenswiki.com
```

This will configure the App to retrieve data from the AWS-hosted Lebenswiki backend.

**Debugging:**

If using VSCode, install the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter).
If using Android Studio, install the [Flutter Plugin](https://plugins.jetbrains.com/plugin/9212-flutter).
Launch your Simulator, and select the IDE's debug button.

**Without Debugging**

Run this command in the projects route directory:

```dart
flutter run
```

## Introduction

The App contains screens for browsing and creating Packs (interactive articles) and Shorts (short user posts). Additional Screens can be accessed through the top-right menu button.

## Architecture Overview

The Architecture follows the principles of Domain-Driven-Design. The Domain containing Models, Repository for getting Data from the backend and casting, Application with helpers managing the data and finally the presentation layer containing the ui.

![Diagram 2_ Data Flow on Navigation to Pack Editor (6).png](https://res.craft.do/user/full/b0e62220-21e7-3e79-e368-d4886dca007e/doc/0A8DC5E9-899D-434B-8E77-6DA9B8314CFB/5028CDAF-4F25-420A-A422-BD3B932F9BA9_2/joLfjOIJUWRABdEcLjDMMzPGzTlj1KQjvMghe8BIW64z/Diagram%202_%20Data%20Flow%20on%20Navigation%20to%20Pack%20Editor%206.png)

Fig 1: Overview Diagram

## Domain

Contains Models and enums. The data layer uses these models to create objects that represent the data received from the backend.

The app uses [json_serializable](https://pub.dev/packages/json_serializable) to generate the model's necessary methods for casting JSON data into objects.

To generate the serialization methods after editing a model, run this command:

```dart
dart run build_runner build
```

## Data

Contains Classes with methods used for accessing the Lebenswiki Backend's API. Each class represents a different resource and extends `BaseApi`, a class with methods for error handling and constants.

All Methods have a return type of `Either`(see [either package](https://pub.dev/packages/either_dart)), containing either an Error or the requested Data.

## Application

Contains classes with helper functions. The classes manage values and objects received from the data layer, and assist with data conversion in the presentation layer.

Important helpers:

| **Class**        | **Use**                                                                           |
| ---------------- | --------------------------------------------------------------------------------- |
| PackConversion   | Conversion of pack items into Widgets                                             |
| TokenHandler     | Manage storage of JWT tokens                                                      |
| StringValidation | Provide Validation Methods                                                        |
| PrefsHandler     | Manage SharedPreferences Storage                                                  |
| CustomRouter     | Handle [Named Routing](https://docs.flutter.dev/cookbook/navigation/named-routes) |

## Presentation

Contains screens, widgets and providers. This layer encompasses the user interface and interacts with the application-, data-, and occasionally the domain-layer.

### State Management

The App utilizes the ChangeNotifier class from [riverpod](https://pub.dev/packages/riverpod) to manage state. 
Existing Notifiers:

- FormNotifier: Assists the authentication screen with validatio
- UserNotifier: Manages user data (captured on login) throughout the App
- SearchNotifier: Maintains search queries and search state

### Screens

Contains all Interfaces presented to the user. Most screens access the data and application layer through a [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html), and show a loading indicator until the casted objects are received.

Folders containing screens:

| **Folder** | **Use**                                     |
| ---------- | ------------------------------------------- |
| main       | Discover and Searching Packs and Shorts     |
| menu       | View Settings, Feedback and Created Content |
| creator    | Creating Packs                              |
| viewer     | Viewing Packs                               |
| other      | Authentication, Avatar Selection            |

### **Routing**

On Startup the main process creates a Go Router, passing the initial page as a parameter.

When navigating to a new page, the App retrieves the users role from the `UserProvider` and checks if the user is permitted to access the route. If permission is confirmed, the app calls `context.go` to navigate to the new page.

### Widgets

Reusable components that are used in various screens.

## Layer-Interactions

When a user chooses to edit a Pack, the router instantiates the Creator page. The editor uses the pack helper to retrieve the pack from the pack api. The pack api gets the pack from the backend and casts it into a Pack Object. The object gets returned to the pack helper and then to the screen, which uses it, as well as widgets, to render the editor screen.

![Leeres Diagramm (2).png](https://res.craft.do/user/full/b0e62220-21e7-3e79-e368-d4886dca007e/doc/E653D7EC-2788-4642-8FEE-1630E069EE7C/A3DBC8A8-FDB3-4E98-83AB-D9AD7F5F11F2_2/FUdiW7sXr8zLsM9MlWWNyFQ14OrTQODjnJ8QBgMliNcz/Leeres%20Diagramm%202.png)

Figure 2: Control Flow Diagram

