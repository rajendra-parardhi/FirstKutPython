import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Commute Setup',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        primaryColor: const Color(0xFF3263AE),
      ),
      home: const CommuteSetupScreen(),
    );
  }
}

class CommuteSetupScreen extends StatefulWidget {
  const CommuteSetupScreen({Key? key}) : super(key: key);

  @override
  State<CommuteSetupScreen> createState() => _CommuteSetupScreenState();
}

class _CommuteSetupScreenState extends State<CommuteSetupScreen> {
  bool _autoPickup = true;
  bool _easyRequest = true;
  bool _companyBilling = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FA), // Root hex_color
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final canvasWidth = constraints.maxWidth;
            final canvasHeight = constraints.maxHeight;

            // Coordinate mapping helpers from [272, 601] canvas design
            double scaleX(double x) => (x / 272.0) * canvasWidth;
            double scaleY(double y) => (y / 601.0) * canvasHeight;

            return Stack(
              children: [
                // Abstract Route Map / Node Network Background
                Positioned(
                  left: scaleX(12),
                  top: scaleY(421),
                  child: Container(
                    width: scaleX(9),
                    height: scaleX(9),
                    decoration: const BoxDecoration(
                      color: Color(0xFFBDCFEB), // ID 8
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: scaleX(31),
                  top: scaleY(421),
                  child: Container(
                    width: scaleX(55),
                    height: scaleY(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D2D3), // ID 4
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Positioned(
                  left: scaleX(104),
                  top: scaleY(365),
                  child: Container(
                    width: scaleX(14),
                    height: scaleY(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC3C4C5), // ID 6
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  left: scaleX(106),
                  top: scaleY(323),
                  child: Container(
                    width: scaleX(7),
                    height: scaleY(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8F9092), // ID 7
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  left: scaleX(147),
                  top: scaleY(421),
                  child: Container(
                    width: scaleX(31),
                    height: scaleY(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCECECF), // ID 5
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Positioned(
                  left: scaleX(150),
                  top: scaleY(220),
                  child: Container(
                    width: scaleX(59),
                    height: scaleY(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3263AE), // ID 2
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Main Title Layer (ID 0)
                Positioned(
                  top: 40,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3263AE).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "ACTIVE",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3263AE),
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "All Set",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Your smart office commute rules are configured.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Detail Options Sheet & Button Panel (ID 3)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA), // ID 3 hex_color
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag Indicator
                        const SizedBox(height: 12),
                        Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Time & Header Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.apartment_rounded, color: Color(0xFF3263AE), size: 22),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Office",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "9:41 AM",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),

                        // Commute Settings List
                        _buildToggleTile(
                          title: "Auto pickup for login rides",
                          value: _autoPickup,
                          onChanged: (val) => setState(() => _autoPickup = val),
                        ),
                        _buildToggleTile(
                          title: "Easy request for logout rides",
                          value: _easyRequest,
                          onChanged: (val) => setState(() => _easyRequest = val),
                        ),
                        _buildToggleTile(
                          title: "Company-managed billing",
                          value: _companyBilling,
                          onChanged: (val) => setState(() => _companyBilling = val),
                        ),

                        // Action Footer (Trips Button)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3263AE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {},
                              child: const Text(
                                "View Active Trips",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
    );
  }

  Widget _buildToggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF3263AE),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}