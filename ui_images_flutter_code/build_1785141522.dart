import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('FirstKutAI_Generated_Layout')),
        body: Container(
          color: Color(0xFFF7EFEF),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('1517 00 0 il', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFFB0A7B1))),
              ),
              Container(
                color: Color(0xFFB71C32),
                height: 108,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 4.0,
                        child: Container(
                          color: Color(0xFFE5ADB6),
                          width: 237.0,
                          height: 269.0,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        elevation: 4.0,
                        child: Container(
                          color: Color(0xFFCA5869),
                          width: 172.0,
                          height: 172.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}