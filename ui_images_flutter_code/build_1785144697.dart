import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FirstKutAIGeneratedLayout(),
      ),
    );
  }
}

class FirstKutAIGeneratedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 253,
          color: Color(0xFFF1EFEF),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 145,
              color: Color(0xFFA5A4AF),
            ),
            SizedBox(width: 39),
            Container(
              width: 94,
              height: 111,
              color: Color(0xFF81818A),
            ),
            SizedBox(width: 24),
            Container(
              width: 94,
              height: 111,
              color: Color(0xFF81818A),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World', style: TextStyle(color: Color(0xFF9695A0))),
            SizedBox(width: 190),
            Container(
              width: 72,
              height: 153,
              color: Color(0xFF9998A3),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('from PaddleOCRl', style: TextStyle(color: Color(0xFF8C8B95))),
            SizedBox(width: 91),
            Container(
              width: 120,
              height: 148,
              color: Color(0xFF91909B),
            ),
            SizedBox(width: 99),
            Container(
              width: 25,
              height: 94,
              color: Color(0xFF48494F),
            ),
            SizedBox(width: 102),
            Container(
              width: 94,
              height: 111,
              color: Color(0xFF82828B),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 31,
              height: 33,
              color: Color(0xFF525359),
            ),
          ],
        ),
        Container(
          height: 253,
          color: Colors.white,
        ),
      ],
    );
  }
}