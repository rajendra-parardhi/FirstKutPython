import 'package:flutter/material.dart';

class DesignPosterWidget extends StatelessWidget {
  const DesignPosterWidget({Key? key}) : super(key: key);

  static const double _canvasWidth = 735.0;
  static const double _canvasHeight = 1105.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: Center(
        child: AspectRatio(
          aspectRatio: _canvasWidth / _canvasHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              double scaleX(double x) => (x / _canvasWidth) * w;
              double scaleY(double y) => (y / _canvasHeight) * h;

              return Container(
                color: const Color(0xFFFAF6F0),
                child: Stack(
                  children: [
                    // Component 0: Main Left Container
                    Positioned(
                      left: scaleX(0),
                      top: scaleY(0),
                      width: scaleX(183),
                      height: scaleY(1102),
                      child: Container(
                        color: const Color(0xFFB38464),
                        child: Stack(
                          children: [
                            // Child 9
                            Positioned(
                              left: (10 / 183) * scaleX(183),
                              top: (660 / 1102) * scaleY(1102),
                              width: (47 / 183) * scaleX(183),
                              height: (45 / 1102) * scaleY(1102),
                              child: Container(
                                color: const Color(0xFFA97451),
                              ),
                            ),
                            // Child 16
                            Positioned(
                              left: (127 / 183) * scaleX(183),
                              top: (589 / 1102) * scaleY(1102),
                              width: (15 / 183) * scaleX(183),
                              height: (17 / 1102) * scaleY(1102),
                              child: Container(
                                color: const Color(0xFF79583B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Component 1: Top-left overlay
                    Positioned(
                      left: scaleX(0),
                      top: scaleY(0),
                      width: scaleX(205),
                      height: scaleY(593),
                      child: Container(
                        color: const Color(0xFFCF9F7F).withOpacity(0.85),
                      ),
                    ),

                    // Component 6: Right Side Container
                    Positioned(
                      left: scaleX(600), // Adjusted relative position to stay in frame
                      top: scaleY(0),
                      width: scaleX(135),
                      height: scaleY(1102),
                      child: Container(
                        color: const Color(0xFF8F6748),
                      ),
                    ),

                    // Component 8: Bottom Left Accent
                    Positioned(
                      left: scaleX(0),
                      top: scaleY(925),
                      width: scaleX(336),
                      height: scaleY(176),
                      child: Container(
                        color: const Color(0xFFA4775B),
                      ),
                    ),

                    // Component 4: Right Bottom Vertical Block
                    Positioned(
                      left: scaleX(630),
                      top: scaleY(757),
                      width: scaleX(101),
                      height: scaleY(243),
                      child: Container(
                        color: const Color(0xFF98623B),
                      ),
                    ),

                    // Component 2: Bottom Mid Box
                    Positioned(
                      left: scaleX(453),
                      top: scaleY(871),
                      width: scaleX(140),
                      height: scaleY(131),
                      child: Container(
                        color: const Color(0xFF926140),
                      ),
                    ),

                    // Component 5: Bottom Small Box
                    Positioned(
                      left: scaleX(576),
                      top: scaleY(908),
                      width: scaleX(51),
                      height: scaleY(66),
                      child: Container(
                        color: const Color(0xFFA66C48),
                      ),
                    ),

                    // Component 3: Vertical Pillar 1
                    Positioned(
                      left: scaleX(215),
                      top: scaleY(748),
                      width: scaleX(23),
                      height: scaleY(123),
                      child: Container(
                        color: const Color(0xFF9B6C4F),
                      ),
                    ),

                    // Component 7: Vertical Pillar 2
                    Positioned(
                      left: scaleX(295),
                      top: scaleY(744),
                      width: scaleX(25),
                      height: scaleY(103),
                      child: Container(
                        color: const Color(0xFF7F5940),
                      ),
                    ),

                    // Component 10: Horizontal Accent Bar
                    Positioned(
                      left: scaleX(446),
                      top: scaleY(394),
                      width: scaleX(107),
                      height: scaleY(17),
                      child: Container(
                        color: const Color(0xFFBB8E5F),
                      ),
                    ),

                    // Component 15: Mid Gray Card
                    Positioned(
                      left: scaleX(226),
                      top: scaleY(302),
                      width: scaleX(36),
                      height: scaleY(49),
                      child: Container(
                        color: const Color(0xFF9E8B87),
                      ),
                    ),

                    // Component 14: Top Accent Ribbon
                    Positioned(
                      left: scaleX(213),
                      top: scaleY(133),
                      width: scaleX(32),
                      height: scaleY(8),
                      child: Container(
                        color: const Color(0xFF727280),
                      ),
                    ),

                    // Component 11: Text "Everything happens"
                    Positioned(
                      left: scaleX(250),
                      top: scaleY(310),
                      child: Text(
                        "Everything happens",
                        style: TextStyle(
                          color: const Color(0xFF8F7D76),
                          fontSize: scaleX(22),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),

                    // Component 12: Text "for a reason"
                    Positioned(
                      left: scaleX(407),
                      top: scaleY(380),
                      child: Text(
                        "for a reason",
                        style: TextStyle(
                          color: const Color(0xFFB98E67),
                          fontSize: scaleX(18),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Component 13: Text "Be patient Trust the process Good things are coming"
                    Positioned(
                      left: scaleX(250),
                      top: scaleY(500),
                      child: SizedBox(
                        width: scaleX(320),
                        child: Text(
                          "Be patient. Trust the process. Good things are coming.",
                          style: TextStyle(
                            color: const Color(0xFFBD8F5D),
                            fontSize: scaleX(14),
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}