import 'package:flutter/material.dart';
import 'chooseImagePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Crop Identification',
        // theme information (colors, font, brightness)
        theme: ThemeData(
            primaryColor: Colors.lightGreen[900],
            fontFamily: 'Oxygen',
            brightness: Brightness.light
        ),
        debugShowCheckedModeBanner: false,
        // home page
        home: ChooseImagePage()
    );
  }
}

// fonts
TextStyle title = new TextStyle(color: Colors.black, fontSize: 24.0, fontFamily: 'Oxygen');
TextStyle subtitle = new TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'Oxygen', fontWeight: FontWeight.bold);
TextStyle body = new TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Oxygen');
TextStyle buttonSmall = new TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'Oxygen');
TextStyle buttonBig = new TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Oxygen');