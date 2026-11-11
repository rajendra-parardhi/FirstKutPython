import 'package:flutter/material.dart';

class DesignIRPoster extends StatelessWidget {
  const DesignIRPoster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the maximum square size that fits the available constraints
        final double size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        
        // Scale factor relative to the 1533x1533 design coordinates
        final double scale = size / 1533.0;

        return Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFF281E28),
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 24 * scale,
                  offset: Offset(0, 12 * scale),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16 * scale),
              child: Stack(
                children: [
                  // ID 4: Main Text Block [0, 0, 1020, 1260]
                  Positioned(
                    left: 0 * scale,
                    top: 0 * scale,
                    width: 1020 * scale,
                    height: 1260 * scale,
                    child: Container(
                      color: const Color(0xFF28202B),
                      // Left padding is adjusted to account for the overlapping Left Column (ID 2, width 252)
                      padding: EdgeInsets.only(
                        left: (252 + 60) * scale,
                        right: 60 * scale,
                        top: 60 * scale,
                        bottom: 60 * scale,
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color(0xFFE8DBE8),
                            fontSize: 32 * scale,
                            fontFamily: 'serif',
                            height: 1.6,
                          ),
                          children: const [
                            TextSpan(
                              text: "Let it be.\n\n",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "What’s meant for you will never miss you, and what misses you was never meant for you.\n\n",
                            ),
                            TextSpan(
                              text: "Choose always peace.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xFFC5B5C5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ID 2: Left Column overlay [0, 0, 252, 1533]
                  Positioned(
                    left: 0 * scale,
                    top: 0 * scale,
                    width: 252 * scale,
                    height: 1533 * scale,
                    child: Container(
                      color: const Color(0xFF1E1925),
                    ),
                  ),

                  // ID 0: Right Column [1023, 0, 255, 1533]
                  Positioned(
                    left: 1023 * scale,
                    top: 0 * scale,
                    width: 255 * scale,
                    height: 1533 * scale,
                    child: Container(
                      color: const Color(0xFF0E0F1C),
                    ),
                  ),

                  // ID 3: Bottom Bar [3, 1245, 1017, 288]
                  Positioned(
                    left: 3 * scale,
                    top: 1245 * scale,
                    width: 1017 * scale,
                    height: 288 * scale,
                    child: Container(
                      color: const Color(0xFF2E181B),
                    ),
                  ),

                  // ID 5: Bottom-Left Block [3, 1269, 390, 264]
                  Positioned(
                    left: 3 * scale,
                    top: 1269 * scale,
                    width: 390 * scale,
                    height: 264 * scale,
                    child: Container(
                      color: const Color(0xFF1F1115),
                    ),
                  ),

                  // ID 9: Small Accent Vertical Block [273, 543, 60, 150]
                  Positioned(
                    left: 273 * scale,
                    top: 543 * scale,
                    width: 60 * scale,
                    height: 150 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF404555),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),

                  // ID 8: Accent Square Block [798, 708, 60, 57]
                  Positioned(
                    left: 798 * scale,
                    top: 708 * scale,
                    width: 60 * scale,
                    height: 57 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF211E2A),
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ),

                  // ID 6: Accent Pill 1 [492, 819, 90, 18]
                  Positioned(
                    left: 492 * scale,
                    top: 819 * scale,
                    width: 90 * scale,
                    height: 18 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF53535C),
                        borderRadius: BorderRadius.circular(9 * scale),
                      ),
                    ),
                  ),

                  // ID 7: Accent Pill 2 [414, 813, 63, 24]
                  Positioned(
                    left: 414 * scale,
                    top: 813 * scale,
                    width: 63 * scale,
                    height: 24 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF56555E),
                        borderRadius: BorderRadius.circular(12 * scale),
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
}