
# Weather App

A simple weather application built with Flutter that allows users to view weather details for their location. The app uses Material 3 design and a dark theme to provide a modern and user-friendly interface.

## Features

- Displays current weather information.
- Allows users to input a location to get weather details.
- Uses a dark theme for a visually appealing experience.

## Screenshots

![Screenshot 1](https://github.com/ak0586/weather_forecast_app/assets/64912402/ad6e0ded-da87-4759-a067-edeae84e8f6a)

![Screenshot 2](https://github.com/ak0586/weather_forecast_app/assets/64912402/484ebcd0-7930-43a3-a5f8-de71b9925c41)


### Getting Started

To get a local copy up and running, follow these steps.

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.

### Installation

1. Clone the repository:
    ```sh
   git clone https://github.com/your-username/weather_app.git

3. Navigate to the project directory:
    ```sh
    cd weather_app
3.  Install dependencies:
    ```sh
    flutter pub get
4.  Run the app:
    ```sh
      flutter run
### Usage
  Open the app to see the current weather information.
  Enter a location in the text field to get weather details for that location.
      
## Code Overview
# Main Entry Point
The '**main.dart**' file is the entry point of the application. It sets up the '**MyApp**' widget, which in turn sets up the '**MaterialApp**' and the home screen.

**code:**
```dart
import 'package:flutter/material.dart';
import 'package:weather_app/weather_material_scaffold_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'weather_app',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyWeatherApp(),
    );
  }
}
```

# Weather Screen
The '**MyWeatherApp**' widget is responsible for displaying the weather information. It includes a '**SingleChildScrollView**' to prevent overflow issues and a '**SafeArea**' to avoid system UI overlaps.
**Code:**
```dart
class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Weather Details'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter location',
                  ),
                ),
                // Add more widgets as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

# Contact
Ankit Kumar - ankitkumar81919895@gmail.com

Project Link: https://github.com/your-username/weather_app
Project Link: https://github.com/ak0586/weather_app
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
