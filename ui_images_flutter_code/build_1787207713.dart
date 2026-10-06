import 'package:flutter/material.dart';

class AllSetDashboard extends StatelessWidget {
  const AllSetDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FA),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;

              // Helper functions to scale coordinates proportionally
              double scaleX(double x) => (x / 599.0) * w;
              double scaleY(double y) => (y / 599.0) * h;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // ID 0: Hero Header Container
                  Positioned(
                    top: scaleY(0),
                    left: scaleX(0),
                    width: scaleX(599),
                    height: scaleY(269),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9F9FA),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: scaleY(40),
                        left: scaleX(40),
                        right: scaleX(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "All Set",
                            style: TextStyle(
                              fontSize: scaleY(38),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF3263AE),
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(height: scaleY(6)),
                          Text(
                            "Everything is ready for your next trip",
                            style: TextStyle(
                              fontSize: scaleY(14),
                              color: const Color(0xFF8F9092),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ID 3: Main Dynamic Button / Preference Card
                  Positioned(
                    top: scaleY(115),
                    left: scaleX(40),
                    width: scaleX(519),
                    height: scaleY(161),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3263AE).withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFEEF0F2),
                          width: 1.5,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: scaleX(20),
                        vertical: scaleY(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: scaleX(8),
                                      vertical: scaleY(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3263AE).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "9:41",
                                      style: TextStyle(
                                        color: Color(0xFF3263AE),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: scaleX(10)),
                                  const Text(
                                    "Office Ride Active",
                                    style: TextStyle(
                                      fontWeight: FontWeight.extrabold,
                                      fontSize: 15,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Color(0xFF8F9092),
                              ),
                            ],
                          ),
                          Container(
                            height: 1.5,
                            color: const Color(0xFFF3F4F6),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildFeatureBadge(Icons.auto_awesome, "Auto Pickup"),
                                SizedBox(width: scaleX(8)),
                                _buildFeatureBadge(Icons.logout, "Easy Request"),
                                SizedBox(width: scaleX(8)),
                                _buildFeatureBadge(Icons.business, "Company Billing"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // ID 8: Light Blue Rounded Dot
                  Positioned(
                    top: scaleY(12),
                    left: scaleX(421),
                    width: scaleX(9),
                    height: scaleY(9),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFBDCFEB),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // ID 4: Light Gray Vertical Timeline/Indicator Pill
                  Positioned(
                    top: scaleY(31),
                    left: scaleX(421),
                    width: scaleX(11),
                    height: scaleY(55),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D2D3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  // ID 5: Medium Gray Pill Accent
                  Positioned(
                    top: scaleY(147),
                    left: scaleX(421),
                    width: scaleX(11),
                    height: scaleY(31),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCECECF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  // ID 7: Horizontal Decorative Line
                  Positioned(
                    top: scaleY(106),
                    left: scaleX(323),
                    width: scaleX(12),
                    height: scaleY(7),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF8F9092),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // ID 6: Small Highlight Dot
                  Positioned(
                    top: scaleY(104),
                    left: scaleX(365),
                    width: scaleX(9),
                    height: scaleY(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3C4C5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // ID 2: Main Blue Indicator Badge/Pill
                  Positioned(
                    top: scaleY(210),
                    left: scaleX(120),
                    width: scaleX(9),
                    height: scaleY(59),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3263AE),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3263AE).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
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
    );
  }

  Widget _buildFeatureBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF3263AE)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}