import 'package:flutter/material.dart';

class QuoteDesignWidget extends StatelessWidget {
  const QuoteDesignWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return Scaffold(
      backgroundColor: const Color(0xFF8D7268),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.0, // 979x979 original canvas ratio
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF9D8076),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double w = constraints.maxWidth;
                  final double h = constraints.maxHeight;

                  // Helper for relative positioning (y, x, height, width relative to 979x979)
                  double relY(double y) => (y / 979.0) * h;
                  double relX(double x) => (x / 979.0) * w;
                  double relH(double height) => (height / 979.0) * h;
                  double relW(double width) => (width / 979.0) * w;

                  return Stack(
                    children: [
                      // Child ID 1: Top Bar Container
                      Positioned(
                        top: relY(0),
                        left: relX(0),
                        width: relW(979),
                        height: relH(120),
                        child: Container(
                          color: const Color(0xFF987568),
                        ),
                      ),

                      // Child ID 7: Bottom Bar Container
                      Positioned(
                        top: relY(735),
                        left: relX(0),
                        width: relW(979),
                        height: relH(120),
                        child: Container(
                          color: const Color(0xFF917B75),
                        ),
                      ),

                      // Decorative Graphic Elements from DesignIR
                      // Child ID 6
                      Positioned(
                        top: relY(277),
                        left: relX(342),
                        width: relW(145),
                        height: relH(185),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF888490).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Child ID 2
                      Positioned(
                        top: relY(321),
                        left: relX(429),
                        width: relW(59),
                        height: relH(76),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6D778F).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      // Child ID 4
                      Positioned(
                        top: relY(381),
                        left: relX(358),
                        width: relW(65),
                        height: relH(68),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF9695A5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      // Child ID 0
                      Positioned(
                        top: relY(383),
                        left: relX(417),
                        width: relW(51),
                        height: relH(80),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF737D96),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),

                      // Child ID 5
                      Positioned(
                        top: relY(528),
                        left: relX(413),
                        width: relW(44),
                        height: relH(78),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF927A73),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),

                      // Child ID 8
                      Positioned(
                        top: relY(561),
                        left: relX(592),
                        width: relW(24),
                        height: relH(42),
                        child: Container(
                          color: const Color(0xFF9A807A),
                        ),
                      ),

                      // Child ID 9
                      Positioned(
                        top: relY(245),
                        left: relX(854),
                        width: relW(3),
                        height: relH(45),
                        child: Container(
                          color: const Color(0xFF98786B),
                        ),
                      ),

                      // Main Quote Text Layer (Root Label)
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.1,
                            vertical: h * 0.15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LET GO OF WHAT WEIGHS YOU DOWN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFF5EBE6),
                                  fontSize: w * 0.048,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2.5,
                                  height: 1.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Focus on what feeds your soul",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFFFF8F5),
                                  fontSize: w * 0.052,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 1.2,
                                  height: 1.4,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}