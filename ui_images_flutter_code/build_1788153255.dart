import 'package:flutter/material.dart';

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double scaleX = constraints.maxWidth / 283.0;
            final double scaleY = constraints.maxHeight / 607.0;

            return Stack(
              children: [
                // Child 0: Main background / content list layer
                Positioned(
                  left: 1 * scaleX,
                  top: 0 * scaleY,
                  width: 279 * scaleX,
                  height: 605 * scaleY,
                  child: Container(
                    color: const Color(0xFFF8F8F9),
                    padding: EdgeInsets.only(
                      top: 175 * scaleY,
                      left: 16 * scaleX,
                      right: 16 * scaleX,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "RECENT SEARCHES",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSearchItem(
                            icon: Icons.history,
                            title: "Secunderabad",
                            subtitle: "Sth Block Rd No 14, Secunderabad",
                          ),
                          _buildSearchItem(
                            icon: Icons.work_outline,
                            title: "Tech Mahindra Office",
                            subtitle: "Block 7, Kukatpally Main Junction, Hyd",
                          ),
                          _buildSearchItem(
                            icon: Icons.local_pizza_outlined,
                            title: "Pista House",
                            subtitle: "Door No 5, Near VED Address, Hyderabad",
                          ),
                          _buildSearchItem(
                            icon: Icons.home_outlined,
                            title: "Home",
                            subtitle: "Friends Colony, Block 7, Kukatpally",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Child 1: Top Search Panel Container
                Positioned(
                  left: 0,
                  top: 0,
                  width: constraints.maxWidth,
                  height: 165 * scaleY,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black87),
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                            const Text(
                              "Search Location",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.location_on, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Current Location",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Search for location...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
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

                // Child 4, 5, 6: Visual indicator decorations positioned explicitly
                Positioned(
                  left: 11 * scaleX,
                  top: 209 * scaleY,
                  width: 27 * scaleX,
                  height: 27 * scaleY,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_city, size: 14, color: Colors.blueGrey),
                  ),
                ),
                Positioned(
                  left: 11 * scaleX,
                  top: 260 * scaleY,
                  width: 27 * scaleX,
                  height: 27 * scaleY,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.business, size: 14, color: Colors.blueGrey),
                  ),
                ),
                Positioned(
                  left: 11 * scaleX,
                  top: 311 * scaleY,
                  width: 27 * scaleX,
                  height: 27 * scaleY,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant, size: 14, color: Colors.blueGrey),
                  ),
                ),

                // Child 2: Bottom action navigation panel
                Positioned(
                  left: 2 * scaleX,
                  bottom: 0,
                  width: 278 * scaleX,
                  height: 75 * scaleY,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEFEFE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBottomNavItem(Icons.map, "Map View", true),
                        _buildBottomNavItem(Icons.favorite_border, "Saved", false),
                        _buildBottomNavItem(Icons.settings, "Settings", false),
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

  Widget _buildSearchItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black45, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? Colors.blue : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.blue : Colors.grey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}