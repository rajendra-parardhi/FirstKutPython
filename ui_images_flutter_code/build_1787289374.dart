import 'package:flutter/material.dart';

class RideTrackingScreen extends StatelessWidget {
  const RideTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBECEA), // Root hex_color
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 250 / 604, // Exact proportions from DesignIR metadata
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double w = constraints.maxWidth;
                final double h = constraints.maxHeight;

                // Scale factor helper functions
                double x(double val) => (val / 250.0) * w;
                double y(double val) => (val / 604.0) * h;

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEA), // Container 1 color
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // --- Container 2: Side map overlay panel ---
                      Positioned(
                        left: x(0),
                        top: y(0),
                        width: x(175),
                        height: y(604),
                        child: Container(
                          color: const Color(0xFFEBEBE6).withOpacity(0.4),
                        ),
                      ),

                      // --- Container 5: Simulated Map / Route Visualization ---
                      Positioned(
                        left: x(21),
                        top: y(0),
                        width: x(145),
                        height: y(319),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6E4DA),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Abstract Map Lines / Paths
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: MapRoutePainter(),
                                ),
                              ),
                              // Map pins
                              Positioned(
                                left: x(50),
                                top: y(100),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                  size: x(18),
                                ),
                              ),
                              Positioned(
                                left: x(100),
                                top: y(200),
                                child: Icon(
                                  Icons.navigation,
                                  color: Colors.blueAccent,
                                  size: x(16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- Container 6: Map Navigation Action (Floating Button) ---
                      Positioned(
                        left: x(11),
                        top: y(111),
                        width: x(42),
                        height: y(28),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFB0CFE8),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),

                      // --- Text 0: Main Info Bottom Sheet / Trip Details Container ---
                      Positioned(
                        left: x(0),
                        top: y(320),
                        width: x(249),
                        height: y(284),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F3F4),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, -3),
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: x(12),
                            vertical: y(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // OTP Header Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Share OTP with driver",
                                        style: TextStyle(
                                          fontSize: x(10),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: y(2)),
                                      Text(
                                        "9313",
                                        style: TextStyle(
                                          fontSize: x(20),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Live Status Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: x(6),
                                      vertical: y(3),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "On the way",
                                      style: TextStyle(
                                        color: Colors.amber[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: x(8),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: y(10)),
                              const Divider(height: 1, color: Colors.black12),
                              SizedBox(height: y(10)),

                              // Driver and Vehicle Details
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: x(16),
                                    backgroundColor: Colors.blueGrey[100],
                                    child: Icon(Icons.person, size: x(18), color: Colors.blueGrey),
                                  ),
                                  SizedBox(width: x(8)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Rajesh Kumar",
                                          style: TextStyle(
                                            fontSize: x(12),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Bajaj Auto",
                                          style: TextStyle(
                                            fontSize: x(9),
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: y(8)),

                              // Pickup Address Text block
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.trip_origin, color: Colors.green, size: x(12)),
                                  SizedBox(width: x(6)),
                                  Expanded(
                                    child: Text(
                                      "Pickup: Block 2 Main Road, Ramraju, Hyderabad, Telangana",
                                      style: TextStyle(
                                        fontSize: x(9),
                                        color: Colors.black54,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- Container 8: Floating Call Button ---
                      Positioned(
                        left: x(179),
                        top: y(426),
                        width: x(23),
                        height: y(22),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF42D67C), // Green call accent
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: x(12),
                          ),
                        ),
                      ),

                      // --- Container 9: Small UI handle / Drag indicator ---
                      Positioned(
                        left: x(35),
                        top: y(478),
                        width: x(24),
                        height: y(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8B9BA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // --- Text 4: Trip Details Action Bar ---
                      Positioned(
                        left: x(0),
                        top: y(530),
                        width: x(240),
                        height: y(27),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: x(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F6FB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.withOpacity(0.1)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Trip Details",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                              fontSize: x(11),
                            ),
                          ),
                        ),
                      ),

                      // --- Text 3: Issue with Pickup Action Bar ---
                      Positioned(
                        left: x(0),
                        top: y(564),
                        width: x(240),
                        height: y(27),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: x(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.1)),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Issue with pickup",
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: x(11),
                                ),
                              ),
                              SizedBox(width: x(4)),
                              // Container 10: Warning Dot Indicator next to Pickup issue
                              Container(
                                width: x(20),
                                height: y(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBB8B4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.9);

    canvas.drawPath(path, paint);

    // Active route highlight
    final activePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..lineTo(size.width * 0.5, size.height * 0.4);

    canvas.drawPath(activePath, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}