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
      title: 'Map Navigation Search',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      ),
      home: const NavigationSearchScreen(),
    );
  }
}

class NavigationSearchScreen extends StatelessWidget {
  const NavigationSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Proportions calibrated based on image dimensions [276, 607]
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: Stack(
        children: [
          // Background "Map" Layer mimicking locate on map texture
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF5F6F7),
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(
                  painter: MapGridPainter(),
                ),
              ),
            ),
          ),

          // Main Interactive Layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Custom Header / Search Bar Panel (derived from id 1, 13)
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Status/Top Info line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "9:41",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.signal_cellular_alt, size: 16),
                              SizedBox(width: 4),
                              Icon(Icons.wifi, size: 16),
                              SizedBox(width: 4),
                              Icon(Icons.battery_full, size: 16),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Card Wrapper (id: 1 style representation)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F2F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // Current Location Row
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "Current Location",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            // Destination Row
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    "Enter destination",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Action Pills (derived from components id 4, 5, 14, 16)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Locate on Map Action
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1EAF9), // Hex: #e1eaf9
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map, color: Colors.blueAccent, size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                "Locate on Map",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Use Current Location Action
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFE9F9), // Hex: #dfe9f9
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.my_location, color: Colors.blue, size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                "Current Loc.",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Saved Addresses Section (id: 7, 8, 6, 9, 12, 17, 10, 11, 15)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SAVED ADDRESSES",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      // Home Location (id: 7, 9, 11)
                      _buildSavedAddressTile(
                        iconColor: const Color(0xFFEBEDEF),
                        icon: Icons.home_rounded,
                        title: "Home",
                        subtitle: "Secunderabad, Hyderabad, 5th Block",
                        distance: "4.7 Km",
                      ),

                      // Work Location (id: 8, 12, 10)
                      _buildSavedAddressTile(
                        iconColor: const Color(0xFFEAECEE),
                        icon: Icons.work_rounded,
                        title: "Work",
                        subtitle: "Tech Mahindra Office, Kukatpally, Hyd",
                        distance: "8.5 Km",
                      ),

                      // Friends Location (id: 6, 17, 15)
                      _buildSavedAddressTile(
                        iconColor: const Color(0xFFECEDEF),
                        icon: Icons.people_rounded,
                        title: "Friends",
                        subtitle: "Pista House Door No 47, Kukatpally",
                        distance: "12 Km",
                      ),
                    ],
                  ),
                ),

                // Bottom Nav/Bar Indicator (id: 2 representation)
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.explore, color: Colors.blueAccent),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_outline, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedAddressTile({
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              distance,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Grid painter to simulate background Map paths
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.5;

    // Draw lines imitating roads/grid structure
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.55), paint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.45, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.6, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}