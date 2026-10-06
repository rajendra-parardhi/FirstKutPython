import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        backgroundColor: Color(0xFF1E2022),
        body: Center(
          child: SmartRidesApp(),
        ),
      ),
    );
  }
}

class SmartRidesApp extends StatelessWidget {
  const SmartRidesApp({super.key});

  // Original design dimensions
  final double designWidth = 278.0;
  final double designHeight = 612.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate fitting scale maintaining original aspect ratio
        double scaleX = constraints.maxWidth / designWidth;
        double scaleY = constraints.maxHeight / designHeight;
        double scale = scaleX < scaleY ? scaleX : scaleY;
        
        // Limit scale so it looks like a clean phone mockup on large screens
        if (scale > 1.2) scale = 1.2;

        return Center(
          child: Container(
            width: designWidth * scale,
            height: designHeight * scale,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDEF),
              borderRadius: BorderRadius.circular(36 * (scale / 1.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36 * (scale / 1.2)),
              child: Stack(
                children: [
                  // ID 0: Base Container Background
                  Positioned(
                    left: 0 * scale,
                    top: 0 * scale,
                    width: 276 * scale,
                    height: 608 * scale,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EEEF),
                      ),
                    ),
                  ),

                  // ID 6: Map/Visual Accent Card
                  Positioned(
                    left: 178 * scale,
                    top: 127 * scale,
                    width: 64 * scale,
                    height: 126 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E1DA),
                        borderRadius: BorderRadius.circular(16 * scale),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Center(
                        child: Icon(
                          Icons.navigation_outlined,
                          size: 20 * scale,
                          color: const Color(0xFF727375),
                        ),
                      ),
                    ),
                  ),

                  // ID 1: Soft sky-blue action pill
                  Positioned(
                    left: 44 * scale,
                    top: 111 * scale,
                    width: 56 * scale,
                    height: 39 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF92DBF2),
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                    ),
                  ),

                  // ID 5: Side Accent Bar
                  Positioned(
                    left: 259 * scale,
                    top: 89 * scale,
                    width: 15 * scale,
                    height: 120 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF85D7E9),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(8 * scale),
                        ),
                      ),
                    ),
                  ),

                  // ID 8: Mini Accent badge top right
                  Positioned(
                    left: 182 * scale,
                    top: 66 * scale,
                    width: 35 * scale,
                    height: 25 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA7E1F4),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                    ),
                  ),

                  // ID 4: Green accent tag/ride option
                  Positioned(
                    left: 1 * scale,
                    top: 203 * scale,
                    width: 66 * scale,
                    height: 52 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA8CB7B),
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(16 * scale),
                        ),
                      ),
                    ),
                  ),

                  // ID 3: Small option card
                  Positioned(
                    left: 93 * scale,
                    top: 207 * scale,
                    width: 35 * scale,
                    height: 26 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9FC9EC),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                    ),
                  ),

                  // ID 9: Small accent container
                  Positioned(
                    left: 137 * scale,
                    top: 211 * scale,
                    width: 28 * scale,
                    height: 23 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA3CDEE),
                        borderRadius: BorderRadius.circular(6 * scale),
                      ),
                    ),
                  ),

                  // ID 10: Extra small visual marker
                  Positioned(
                    left: 248 * scale,
                    top: 227 * scale,
                    width: 17 * scale,
                    height: 15 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E8E9),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),

                  // ID 16: Micro notification dot/pill
                  Positioned(
                    left: 8 * scale,
                    top: 170 * scale,
                    width: 5 * scale,
                    height: 7 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F4F4),
                        borderRadius: BorderRadius.circular(2 * scale),
                      ),
                    ),
                  ),

                  // ID 2: Main Text Content Block (Styled beautifully)
                  Positioned(
                    left: 16 * scale,
                    top: 0 * scale,
                    width: 246 * scale,
                    height: 610 * scale,
                    child: IgnorePointer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Bar simulation (9:41)
                          SizedBox(height: 14 * scale),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "9:41",
                                style: TextStyle(
                                  fontSize: 12 * scale,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.signal_cellular_alt, size: 12 * scale, color: Colors.black87),
                                  SizedBox(width: 4 * scale),
                                  Icon(Icons.wifi, size: 12 * scale, color: Colors.black87),
                                  SizedBox(width: 4 * scale),
                                  Icon(Icons.battery_full, size: 12 * scale, color: Colors.black87),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 36 * scale),
                          // Title Header
                          Text(
                            "Smart rides\none app.",
                            style: TextStyle(
                              fontSize: 24 * scale,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2C3A42),
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 38 * scale),
                          // Subtitles & Actionable list items representing the JSON text labels
                          _buildRideOption("Personal anytime", "Fast individual rides", scale),
                          SizedBox(height: 14 * scale),
                          _buildRideOption("Easy office commutes", "Corporate scheduled pools", scale),
                          SizedBox(height: 14 * scale),
                          _buildRideOption("Shared scheduled trips", "Eco-friendly, budget travel", scale),
                        ],
                      ),
                    ),
                  ),

                  // Navigation / Control indicators
                  // ID 12: Active dot
                  Positioned(
                    left: 52 * scale,
                    top: 326 * scale,
                    width: 9 * scale,
                    height: 11 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF727375),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                  // ID 17: Inactive dot/pill
                  Positioned(
                    left: 105 * scale,
                    top: 321 * scale,
                    width: 11 * scale,
                    height: 16 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8B9BA),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                  // ID 11: Inactive dot
                  Positioned(
                    left: 158 * scale,
                    top: 326 * scale,
                    width: 11 * scale,
                    height: 11 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9E9FA0),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                  // ID 15: Inactive dot
                  Positioned(
                    left: 207 * scale,
                    top: 326 * scale,
                    width: 10 * scale,
                    height: 11 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A9B9C),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),

                  // Bottom Pill / Footer controls (ID 13 & 14)
                  Positioned(
                    left: 87 * scale,
                    top: 424 * scale,
                    width: 57 * scale,
                    height: 9 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9C9CA),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 148 * scale,
                    top: 424 * scale,
                    width: 25 * scale,
                    height: 10 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBCCCC),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRideOption(String title, String subtitle, double scale) {
    return Container(
      padding: EdgeInsets.all(10 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8 * scale,
            height: 24 * scale,
            decoration: BoxDecoration(
              color: const Color(0xFF92DBF2),
              borderRadius: BorderRadius.circular(4 * scale),
            ),
          ),
          SizedBox(width: 8 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3A42),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8 * scale,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 10 * scale,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}