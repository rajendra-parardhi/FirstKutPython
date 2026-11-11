import 'package:flutter/material.dart';

class LifeLessonsPoster extends StatelessWidget {
  const LifeLessonsPoster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBCA186),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: const Color(0xFFBCA186),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Top Accent Banner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 120,
                        height: 180,
                        decoration: const BoxDecoration(
                          color: Color(0xFF9E8367),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                          ),
                        ),
                      ),
                    ),

                    // Side Vertical Ribbon Accent
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        color: const Color(0xFFBDA790),
                      ),
                    ),

                    // Main Quote Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36.0,
                        vertical: 48.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA39588).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "DAILY REFLECTION",
                              style: TextStyle(
                                color: Color(0xFF543E2D),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Main Title
                          const Text(
                            "Life's Lessons",
                            style: TextStyle(
                              color: Color(0xFF543E2D),
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              fontFamily: 'Serif',
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Decorative Pill Dividers
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC6B7A6),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 24,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBBCAB),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Stanza 1
                          _buildQuoteLine("Not every door is meant for you,"),
                          const SizedBox(height: 12),
                          _buildQuoteLine("Not every chapter is meant to stay."),
                          const SizedBox(height: 24),

                          // Highlight Box (Protection)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCE8D54),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Some endings are protection.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Stanza 2
                          _buildQuoteLine("And every lesson"),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBE8D65).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "is preparing you.",
                              style: TextStyle(
                                color: Color(0xFF543E2D),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Footer Card - Call to Action / Affirmation
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF73553B),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6B5037),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Keep",
                                        style: TextStyle(
                                          color: Color(0xFFBDA790),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "trusting the process",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7D593D),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Grow through what you go through",
                                        style: TextStyle(
                                          color: Color(0xFFBDA790),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.auto_awesome,
                                        color: Color(0xFFCE8D54),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteLine(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF543E2D),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }
}