import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF211B22),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF211B22),
          child: Column(
            children: [
              Expanded(
                flex: 367,
                child: Container(
                  color: Color(0xFF211B22),
                ),
              ),
              Expanded(
                flex: 314,
                child: Container(
                  color: Color(0xFF221C23),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          color: Color(0xFFA94740),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Send',
                            style: TextStyle(
                              color: Color(0xFFEA5E57),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 314,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color(0xFFA94740),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Select slot',
                          style: TextStyle(
                            color: Color(0xFF23232A),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 314,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color(0xFFA94740),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Select location',
                          style: TextStyle(
                            color: Color(0xFF23232A),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 314,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color(0xFFA94740),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Enter you number',
                          style: TextStyle(
                            color: Color(0xFF26272F),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 314,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Color(0xFFA94740),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Enter email address',
                          style: TextStyle(
                            color: Color(0xFF292B35),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}