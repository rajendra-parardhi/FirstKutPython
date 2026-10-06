[FLUTTER_START]
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color(0xFF1B060A),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 24.0,
                    height: 84.0,
                    color: Color(0xFFC50E30),
                  ),
                  Container(
                    width: 28.0,
                    height: 44.0,
                    color: Color(0xFF7D091E),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 27.0,
                          height: 36.0,
                          color: Color(0xFF010203),
                        ),
                        Container(
                          width: 24.0,
                          height: 27.0,
                          color: Color(0xFF020203),
                        ),
                        Container(
                          width: 23.0,
                          height: 27.0,
                          color: Color(0xFF020203),
                        ),
                        Container(
                          width: 23.0,
                          height: 26.0,
                          color: Color(0xFF020203),
                        ),
                        Container(
                          width: 8.0,
                          height: 35.0,
                          color: Color(0xFF020304),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 14.0,
                          height: 19.0,
                          color: Color(0xFF010202),
                        ),
                        Container(
                          width: 14.0,
                          height: 15.0,
                          color: Color(0xFF010102),
                        ),
                        Container(
                          width: 13.0,
                          height: 15.0,
                          color: Color(0xFF020203),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 7.0,
                          height: 25.0,
                          color: Color(0xFF030405),
                        ),
                        Container(
                          width: 11.0,
                          height: 13.0,
                          color: Color(0xFF000101),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 7.0,
                          height: 11.0,
                          color: Color(0xFF232323),
                        ),
                        Container(
                          width: 7.0,
                          height: 10.0,
                          color: Color(0xFF2A2A2A),
                        ),
                        Container(
                          width: 7.0,
                          height: 10.0,
                          color: Color(0xFF363535),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
[FLUTTER_END]