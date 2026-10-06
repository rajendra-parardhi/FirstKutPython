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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        fontFamily: 'Roboto',
      ),
      home: const MapSearchScreen(),
    );
  }
}

class MapSearchScreen extends StatelessWidget {
  const MapSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            color: const Color(0xFFF7F7F8),
            child: Column(
              children: [
                // Search Header Section
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black87),
                            onPressed: () {},
                          ),
                          const Expanded(
                            child: Text(
                              "Locate on Map",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Destination input boxes (mimicking ID 1 & 13)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F2F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.radio_button_checked, color: Colors.blue),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: "Current Location",
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: Colors.black12),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.redAccent),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter destination",
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Use Current Location / Quick chips (ID 4, 5, 14, 16 area)
                      Row(
                        children: [
                          _buildQuickChip(
                            icon: Icons.my_location,
                            iconBgColor: const Color(0xFFE1EAF9),
                            iconColor: Colors.blue,
                            label: "Use Current Location",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Saved/Recent Places list (ID 6, 7, 8, 9, 10, 11, 12, 17 area)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "SAVED ADDRESSES",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      // Home Place (ID 7, 9, 11)
                      _buildPlaceRow(
                        icon: Icons.home,
                        iconBgColor: const Color(0xFFEBEDEF),
                        title: "Home",
                        subtitle: "Block 7, Kukatpally, Hyderabad",
                        distance: "4.7 Km",
                      ),
                      // Work Place (ID 8, 12, 10)
                      _buildPlaceRow(
                        icon: Icons.work,
                        iconBgColor: const Color(0xFFEAECEE),
                        title: "Work",
                        subtitle: "Tech Mahindra Office, Bahadurpally",
                        distance: "8.5 Km",
                      ),
                      // Friends Place (ID 6, 17, 15)
                      _buildPlaceRow(
                        icon: Icons.people,
                        iconBgColor: const Color(0xFFECEDEF),
                        title: "Friends",
                        subtitle: "Door No 4-733/1A, Secunderabad",
                        distance: "12 Km",
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation Container (ID 2 visual)
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFE2E3E7), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomNavItem(Icons.explore, "Explore", true),
                      _buildBottomNavItem(Icons.bookmark, "Saved", false),
                      _buildBottomNavItem(Icons.person, "Profile", false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceRow({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            distance,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? Colors.blue : Colors.black38;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}