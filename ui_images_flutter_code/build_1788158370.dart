import 'package:flutter/material.dart';

class EnrichedDesignWidget extends StatelessWidget {
  const EnrichedDesignWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Base design size is 320x206
        final double scale = constraints.maxWidth / 320.0;
        final double containerHeight = 206.0 * scale;

        return Center(
          child: Container(
            width: constraints.maxWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Component 10 (Text / Header Area with nested children)
                Positioned(
                  left: 0 * scale,
                  top: 0 * scale,
                  width: 319 * scale,
                  height: 145 * scale,
                  child: Container(
                    color: const Color(0xFF1B060A),
                    child: Stack(
                      children: [
                        // Label text inside component 10
                        Positioned(
                          left: 10 * scale,
                          right: 10 * scale,
                          bottom: 12 * scale,
                          child: Text(
                            "e 3 Global Thinkors Engaged Leaders",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5 * scale,
                            ),
                          ),
                        ),
                        // Child 0
                        Positioned(
                          left: 50 * scale,
                          top: 6 * scale,
                          width: 25 * scale,
                          height: 83 * scale,
                          child: Container(color: const Color(0xFFC50E30)),
                        ),
                        // Child 9
                        Positioned(
                          left: 29 * scale,
                          top: 5 * scale,
                          width: 20 * scale,
                          height: 87 * scale,
                          child: Container(color: const Color(0xFF060001)),
                        ),
                        // Child 12
                        Positioned(
                          left: 0 * scale,
                          top: 6 * scale,
                          width: 28 * scale,
                          height: 44 * scale,
                          child: Container(color: const Color(0xFF7D091E)),
                        ),
                        // Child 7
                        Positioned(
                          left: 236 * scale,
                          top: 5 * scale,
                          width: 27 * scale,
                          height: 36 * scale,
                          child: Container(color: const Color(0xFF010202)),
                        ),
                        // Child 5
                        Positioned(
                          left: 288 * scale,
                          top: 14 * scale,
                          width: 24 * scale,
                          height: 26 * scale,
                          child: Container(color: const Color(0xFF020203)),
                        ),
                        // Child 4
                        Positioned(
                          left: 208 * scale,
                          top: 14 * scale,
                          width: 23 * scale,
                          height: 26 * scale,
                          child: Container(color: const Color(0xFF020203)),
                        ),
                        // Child 8
                        Positioned(
                          left: 135 * scale,
                          top: 14 * scale,
                          width: 23 * scale,
                          height: 26 * scale,
                          child: Container(color: const Color(0xFF020203)),
                        ),
                        // Child 3
                        Positioned(
                          left: 193 * scale,
                          top: 5 * scale,
                          width: 8 * scale,
                          height: 35 * scale,
                          child: Container(color: const Color(0xFF020203)),
                        ),
                        // Child 16
                        Positioned(
                          left: 215 * scale,
                          top: 55 * scale,
                          width: 14 * scale,
                          height: 19 * scale,
                          child: Container(color: const Color(0xFF010202)),
                        ),
                        // Child 6
                        Positioned(
                          left: 114 * scale,
                          top: 55 * scale,
                          width: 14 * scale,
                          height: 15 * scale,
                          child: Container(color: const Color(0xFF010203)),
                        ),
                        // Child 15
                        Positioned(
                          left: 139 * scale,
                          top: 55 * scale,
                          width: 14 * scale,
                          height: 15 * scale,
                          child: Container(color: const Color(0xFF010102)),
                        ),
                        // Child 2
                        Positioned(
                          left: 195 * scale,
                          top: 15 * scale,
                          width: 7 * scale,
                          height: 25 * scale,
                          child: Container(color: const Color(0xFF030405)),
                        ),
                        // Child 13
                        Positioned(
                          left: 245 * scale,
                          top: 80 * scale,
                          width: 14 * scale,
                          height: 11 * scale,
                          child: Container(color: const Color(0xFF303030)),
                        ),
                        // Child 22
                        Positioned(
                          left: 244 * scale,
                          top: 21 * scale,
                          width: 11 * scale,
                          height: 12 * scale,
                          child: Container(color: const Color(0xFF000001)),
                        ),
                        // Child 14
                        Positioned(
                          left: 173 * scale,
                          top: 21 * scale,
                          width: 7 * scale,
                          height: 18 * scale,
                          child: Container(color: const Color(0xFF000000)),
                        ),
                        // Child 18
                        Positioned(
                          left: 172 * scale,
                          top: 55 * scale,
                          width: 8 * scale,
                          height: 15 * scale,
                          child: Container(color: const Color(0xFF010203)),
                        ),
                        // Child 20
                        Positioned(
                          left: 196 * scale,
                          top: 50 * scale,
                          width: 5 * scale,
                          height: 20 * scale,
                          child: Container(color: const Color(0xFF010203)),
                        ),
                        // Child 17
                        Positioned(
                          left: 117 * scale,
                          top: 80 * scale,
                          width: 8 * scale,
                          height: 11 * scale,
                          child: Container(color: const Color(0xFF2F2E2E)),
                        ),
                        // Child 24
                        Positioned(
                          left: 140 * scale,
                          top: 80 * scale,
                          width: 8 * scale,
                          height: 11 * scale,
                          child: Container(color: const Color(0xFF212121)),
                        ),
                        // Child 26
                        Positioned(
                          left: 168 * scale,
                          top: 80 * scale,
                          width: 7 * scale,
                          height: 11 * scale,
                          child: Container(color: const Color(0xFF363535)),
                        ),
                        // Child 25
                        Positioned(
                          left: 220 * scale,
                          top: 83 * scale,
                          width: 7 * scale,
                          height: 10 * scale,
                          child: Container(color: const Color(0xFF444343)),
                        ),
                        // Child 11
                        Positioned(
                          left: 193 * scale,
                          top: 5 * scale,
                          width: 8 * scale,
                          height: 8 * scale,
                          child: Container(color: const Color(0xFF020304)),
                        ),
                        // Child 19
                        Positioned(
                          left: 197 * scale,
                          top: 55 * scale,
                          width: 4 * scale,
                          height: 15 * scale,
                          child: Container(color: const Color(0xFF020303)),
                        ),
                        // Child 21
                        Positioned(
                          left: 273 * scale,
                          top: 83 * scale,
                          width: 6 * scale,
                          height: 8 * scale,
                          child: Container(color: const Color(0xFF434242)),
                        ),
                        // Child 23
                        Positioned(
                          left: 142 * scale,
                          top: 30 * scale,
                          width: 8 * scale,
                          height: 5 * scale,
                          child: Container(color: const Color(0xFF000000)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Component 1 (Bottom Dark Container)
                Positioned(
                  left: 0 * scale,
                  top: 92 * scale,
                  width: 319 * scale,
                  height: 114 * scale,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF040203),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}