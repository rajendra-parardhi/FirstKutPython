import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaddleOCR Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Background color from JSON: #dedbeb
    const Color backgroundColor = Color(0xFFDEDBEB);
    // Text color sampled from image: a dark gray, similar to #3A3A3E or #494a50
    const Color textColor = Color(0xFF3A3A3E); // Using a slightly darker shade for contrast

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Hello World',
              style: TextStyle(
                fontFamily: 'Roboto', // Using Roboto as a common sans-serif font
                fontSize: 80, // Large font size to match the screenshot
                fontWeight: FontWeight.w600, // Semi-bold for good readability
                color: textColor,
                height: 1.2, // Adjust line height for visual balance
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16), // Spacing between the two lines
            Text(
              'from PaddleOCR!', // Corrected from 'PaddleOCRl' based on visual
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 80, // Same font size as the first line
                fontWeight: FontWeight.w600,
                color: textColor,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}