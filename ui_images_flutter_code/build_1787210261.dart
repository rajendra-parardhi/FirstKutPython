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
      title: 'Ride Booking UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        backgroundColor: Color(0xFFF5F5F7),
        body: Center(
          child: RideBookingWidget(),
        ),
      ),
    );
  }
}

class RideBookingWidget extends StatelessWidget {
  const RideBookingWidget({Key? key}) : super(key: key);

  // Target aspect ratio based on DesignIR metadata
  static const double targetWidth = 218.0;
  static const double targetHeight = 607.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 375, // Scaled for normal mobile screen simulation
        height: 812,
        color: const Color(0xFFECEDED),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double scaleX = constraints.maxWidth / targetWidth;
            final double scaleY = constraints.maxHeight / targetHeight;

            // Helper function to build Positioned widgets using design coordinates
            Widget buildPositioned({
              required double left,
              required double top,
              required double width,
              required double height,
              required Widget child,
            }) {
              return Positioned(
                left: left * scaleX,
                top: top * scaleY,
                width: width * scaleX,
                height: height * scaleY,
                child: child,
              );
            }

            return Stack(
              children: [
                // Child 2: Map Background Area
                buildPositioned(
                  left: 0,
                  top: 0,
                  width: 192,
                  height: 605,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEEFEF),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Abstract map elements (optional styling)
                        Positioned(
                          top: 80,
                          left: 30,
                          child: Container(
                            width: 120,
                            height: 6,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 50,
                          child: Container(
                            width: 6,
                            height: 200,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Child 12: Top Bar Header Area
                buildPositioned(
                  left: 0,
                  top: 0,
                  width: 213,
                  height: 133,
                  child: Container(
                    color: const Color(0xFFDDDEDC),
                  ),
                ),

                // Child 6: Header Element
                buildPositioned(
                  left: 9,
                  top: 0,
                  width: 71,
                  height: 133,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6E0CE),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),

                // Child 26: Top accent bar / logo element
                buildPositioned(
                  left: 124,
                  top: 0,
                  width: 15,
                  height: 66,
                  child: Container(
                    color: const Color(0xFFEDEEF2),
                  ),
                ),

                // Child 3: Enter Location Title
                buildPositioned(
                  left: 73,
                  top: 69,
                  width: 64,
                  height: 13,
                  child: const Text(
                    "Enter Location",
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F4245),
                    ),
                  ),
                ),

                // Child 23: Bottom Sheet / Services Panel Base
                buildPositioned(
                  left: 0,
                  top: 136,
                  width: 213,
                  height: 469,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        )
                      ],
                    ),
                  ),
                ),

                // Child 7: Pick Up Location Input Background
                buildPositioned(
                  left: 5,
                  top: 151,
                  width: 196,
                  height: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.only(left: 40, right: 30),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Pick up Current Location",
                      style: TextStyle(fontSize: 8, color: Colors.black54),
                    ),
                  ),
                ),

                // Child 15: Pickup Icon Indicator
                buildPositioned(
                  left: 14,
                  top: 161,
                  width: 26,
                  height: 26,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7EEFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.my_location, size: 12, color: Colors.blue),
                    ),
                  ),
                ),

                // Child 4: Destination Input Background
                buildPositioned(
                  left: 5,
                  top: 205,
                  width: 196,
                  height: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.only(left: 40, right: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Click to Enter Destination",
                      style: TextStyle(fontSize: 8, color: Colors.black38),
                    ),
                  ),
                ),

                // Child 14: Destination Icon Indicator
                buildPositioned(
                  left: 14,
                  top: 214,
                  width: 26,
                  height: 26,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9F0FC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on, size: 12, color: Colors.redAccent),
                    ),
                  ),
                ),

                // Child 20: Input side detail / Arrow selector
                buildPositioned(
                  left: 171,
                  top: 167,
                  width: 23,
                  height: 14,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E5F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.keyboard_arrow_right, size: 10, color: Colors.blue),
                  ),
                ),

                // Child 18: Map shortcut tag
                buildPositioned(
                  left: 176,
                  top: 263,
                  width: 27,
                  height: 13,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        "MAP",
                        style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),

                // Ride Service Option 1
                buildPositioned(
                  left: 74,
                  top: 282,
                  width: 60,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EAED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_car, size: 24, color: Colors.blueGrey),
                  ),
                ),

                // Child 8: Service Option 1 Label Base
                buildPositioned(
                  left: 74,
                  top: 316,
                  width: 59,
                  height: 26,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F6),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Comfort",
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                // Ride Service Option 2
                buildPositioned(
                  left: 143,
                  top: 282,
                  width: 60,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.electric_car, size: 24, color: Colors.green),
                  ),
                ),

                // Child 10: Service Option 2 Label Base
                buildPositioned(
                  left: 144,
                  top: 316,
                  width: 59,
                  height: 26,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F8),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Eco Ride",
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ),
                  ),
                ),

                // Ride Service Option 3 (Economy Card)
                buildPositioned(
                  left: 74,
                  top: 352,
                  width: 60,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E8EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "E",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),

                // Option Indicators / Small layout anchors
                buildPositioned(
                  left: 21,
                  top: 363,
                  width: 28,
                  height: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFABB0B1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.arrow_back, size: 8, color: Colors.white),
                  ),
                ),
                buildPositioned(
                  left: 160,
                  top: 363,
                  width: 28,
                  height: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFACB1B2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.arrow_forward, size: 8, color: Colors.white),
                  ),
                ),

                // Child 16: Fare Section Background
                buildPositioned(
                  left: 5,
                  top: 420,
                  width: 199,
                  height: 43,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F5F4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Child 13: Fare Label
                buildPositioned(
                  left: 15,
                  top: 422,
                  width: 137,
                  height: 42,
                  child: Row(
                    children: const [
                      Icon(Icons.payment, size: 12, color: Colors.orangeAccent),
                      SizedBox(width: 4),
                      Text(
                        "Estimated Fare",
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Child 11: Pay Button
                buildPositioned(
                  left: 144,
                  top: 422,
                  width: 59,
                  height: 42,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE5E1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Pay",
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF6D4C41)),
                      ),
                    ),
                  ),
                ),

                // Child 21: RECENT SEARCHES Title
                buildPositioned(
                  left: 14,
                  top: 477,
                  width: 100,
                  height: 15,
                  child: const Text(
                    "RECENT SEARCHES",
                    style: TextStyle(
                      fontSize: 6,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),

                // Child 23: Text list of locations
                buildPositioned(
                  left: 14,
                  top: 495,
                  width: 190,
                  height: 70,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "• Secunderabad Hxtlurandd",
                          style: TextStyle(fontSize: 7, color: Colors.black54),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "• Cush Back Podl Corpcrntu Ride",
                          style: TextStyle(fontSize: 7, color: Colors.black54),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "• Services Elcn nual Htnunad",
                          style: TextStyle(fontSize: 7, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation Dots / Bar
                buildPositioned(
                  left: 26,
                  top: 578,
                  width: 13,
                  height: 13,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF6D94D4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                buildPositioned(
                  left: 71,
                  top: 578,
                  width: 13,
                  height: 13,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFB6B7B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                buildPositioned(
                  left: 122,
                  top: 578,
                  width: 11,
                  height: 13,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4D5D6),
                      shape: BoxShape.circle,
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
}