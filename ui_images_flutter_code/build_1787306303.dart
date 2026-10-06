import 'package:flutter/material.dart';

class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE2E7),
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 276 / 605,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2E7),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 4,
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth;
                    final double h = constraints.maxHeight;

                    // Absolute coordinate converter helper (based on 276 x 605 original spec)
                    double x(double val) => (val / 276.0) * w;
                    double y(double val) => (val / 605.0) * h;

                    return Stack(
                      children: [
                        // ID 1: Background canvas layer 1
                        Positioned(
                          left: x(0),
                          top: y(0),
                          width: x(275),
                          height: y(603),
                          child: Container(
                            color: const Color(0xFFDDE2E7),
                          ),
                        ),

                        // ID 2: Background canvas layer 2
                        Positioned(
                          left: x(0),
                          top: y(0),
                          width: x(161),
                          height: y(603),
                          child: Container(
                            color: const Color(0xFFDAE1E7),
                          ),
                        ),

                        // ID 4: Map Visual Element (simulated land/building plot)
                        Positioned(
                          left: x(81),
                          top: y(126),
                          width: x(160),
                          height: y(368),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4E4DC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                        // ID 6: Small indicator/block above map element
                        Positioned(
                          left: x(1),
                          top: y(126),
                          width: x(81),
                          height: y(15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEBEE),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                        // ID 8: Visual map pin anchor / Highlighted Area
                        Positioned(
                          left: x(40),
                          top: y(245),
                          width: x(102),
                          height: y(119),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCE0D4).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFA2C7B1),
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.my_location,
                                color: Color(0xFF2E7D32),
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        // ID 5: Header Search Box
                        Positioned(
                          left: x(1),
                          top: y(0),
                          width: x(272),
                          height: y(122),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF6F7F8),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(24),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Set Pickup Location",
                                      style: TextStyle(
                                        fontSize: w * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.search, color: Colors.blueAccent, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Search location",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: w * 0.038,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ID 3: Selected Location Information Sheet
                        Positioned(
                          left: x(1),
                          top: y(495),
                          width: x(272),
                          height: y(108),
                          child: Container(
                            padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 45),
                            decoration: const BoxDecoration(
                              color: Color(0xFFADBFE1),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SELECTED LOCATION",
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.blue.shade900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    "47333A Block 7 Kukatpally Main Junction Hyderabad",
                                    style: TextStyle(
                                      fontSize: w * 0.035,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ID 9: Small Location Icon inside Location Sheet
                        Positioned(
                          left: x(7),
                          top: y(508),
                          width: x(27),
                          height: y(27),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1EAF9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF1655BA),
                              size: 16,
                            ),
                          ),
                        ),

                        // IDs 12, 13, 10, 11: Horizontal Action/Status Indicators Row
                        Positioned(
                          left: x(43),
                          top: y(522),
                          width: x(36),
                          height: y(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFBDBEBF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(88),
                          top: y(521),
                          width: x(46),
                          height: y(9),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFC5C5C6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(138),
                          top: y(522),
                          width: x(30),
                          height: y(7),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFC2C3C4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Positioned(
                          left: x(176),
                          top: y(522),
                          width: x(47),
                          height: y(9),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFBBBCBD),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),

                        // ID 0: Main Confirm CTA Button
                        Positioned(
                          left: x(7),
                          top: y(555),
                          width: x(257),
                          height: y(36),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1655BA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              "Confirm Location",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}