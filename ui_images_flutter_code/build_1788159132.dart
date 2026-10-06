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
      title: 'Location Search',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        fontFamily: 'Roboto',
      ),
      home: const LocationSearchScreen(),
    );
  }
}

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "9:41",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFFC3C4C6),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt, size: 14, color: Color(0xFFC3C4C6)),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 14, color: Color(0xFFC3C4C6)),
                      SizedBox(width: 4),
                      Icon(Icons.battery_std, size: 14, color: Color(0xFFC3C4C6)),
                    ],
                  )
                ],
              ),
            ),

            // Search Header Box
            Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.black54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Pickup Location",
                            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SEARCH RESULTS",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Search Results List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildResultItem(
                    icon: Icons.history,
                    title: "Jagavis Kritunga Restaurant",
                    subtitle: "Block-C, Main Road, Kukatpally, Hyderabad",
                    distance: "2.2 km",
                  ),
                  _buildResultItem(
                    icon: Icons.location_on_outlined,
                    title: "Jaya Mithai Shop",
                    subtitle: "Block-Z, Main Road, Kukatpally, Hyderabad",
                    distance: "2.6 km",
                  ),
                  _buildResultItem(
                    icon: Icons.location_on_outlined,
                    title: "Jail Mandi House",
                    subtitle: "Door No. 4-73/34, Block-A, Kukatpally",
                    distance: "2.1 km",
                  ),
                  _buildResultItem(
                    icon: Icons.history,
                    title: "Kukatpally Main Junction",
                    subtitle: "National Highway 65, Kukatpally, Hyderabad",
                    distance: "2.2 km",
                  ),
                  _buildResultItem(
                    icon: Icons.location_on_outlined,
                    title: "Jaya Mithai Bakery",
                    subtitle: "Block-B, Kukatpally Main Rd, Hyderabad",
                    distance: "2.6 km",
                  ),
                  _buildResultItem(
                    icon: Icons.location_on_outlined,
                    title: "Kritunga Food Court",
                    subtitle: "Metro Station Pillar A-734, Hyderabad",
                    distance: "0.7 km",
                  ),
                ],
              ),
            ),

            // Bottom White Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFEFEFE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E9EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.map, color: Colors.black85),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Choose on Map",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Set location by dragging the pin",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E9EC),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.black54),
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
                    color: Colors.black85,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, py: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              distance,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}