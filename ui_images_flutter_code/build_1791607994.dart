import 'package:flutter/material.dart';

class InspirationalQuoteScreen extends StatelessWidget {
  const InspirationalQuoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9D8076),
      body: SafeArea(
        child: Column(
          children: [
            // Top Accent Bar (id: 1)
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFF987568),
            ),
            
            // Central Content Area
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Decorative graphic containers (ids: 6, 2, 4, 0, 5)
                      Positioned(
                        top: 40,
                        child: Container(
                          width: 180,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF888490).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 40,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6D778F),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        right: 50,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9695A5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 60,
                        child: Container(
                          width: 90,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF737D96),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        right: 40,
                        child: Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF927A73),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),

                      // Main Quote Text Container (id: 3 root text)
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9D8076).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "“",
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.white70,
                                fontFamily: 'Serif',
                                height: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Let go of what weighs you down.\nFocus on what feeds your soul.",
                              textAlign: TextAlign.Center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                height: 1.5,
                                letterSpacing: 0.8,
                                fontFamily: 'Serif',
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Small Accent Divider (id: 9)
                            Container(
                              width: 45,
                              height: 3,
                              color: const Color(0xFF98786B),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Accent Bar (id: 7)
            Container(
              height: 60,
              width: double.infinity,
              color: const Color(0xFF917B75),
              alignment: Alignment.center,
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF9A807A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}