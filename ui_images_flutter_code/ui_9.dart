import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gauge UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GaugeScreen(),
    );
  }
}

class GaugeScreen extends StatelessWidget {
  const GaugeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background as per image
      body: Center(
        child: Container(
          width: 400, // Based on HTML/image width
          height: 271, // Based on JSON bbox height
          decoration: BoxDecoration(
            color: Colors.black, // Ensure container background is black
            borderRadius: BorderRadius.circular(10),
            boxShadow: [ // Subtle shadow as per guidelines
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.bottomCenter, // Align gauge bottom to container bottom
            children: [
              CustomPaint(
                size: const Size(400, 200), // Max width, and height for semi-circle
                painter: GaugePainter(
                  value: 71,
                  minValue: 0,
                  maxValue: 300,
                  strokeWidth: 40,
                  greenColor: const Color(0xFF4CAF50), // Material Green 500
                  goldenColor: const Color(0xFFFFC107), // Material Amber 500
                  redColor: const Color(0xFFF44336), // Material Red 500
                  indicatorColor: Colors.white,
                  trackColor: const Color(0xFF333333), // Dark gray for background track
                ),
              ),
              // Central value '71'
              Positioned(
                top: 130, // Adjust vertical positioning
                child: Text(
                  '71',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    height: 1, // Adjust line height for better vertical alignment
                  ),
                ),
              ),
              // Labels
              ..._buildLabels(
                size: const Size(400, 200),
                strokeWidth: 40,
                values: {'0': 0, '100': 100, '200': 200, '300': 300},
                minValue: 0,
                maxValue: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLabels({
    required Size size,
    required double strokeWidth,
    required Map<String, int> values,
    required double minValue,
    required double maxValue,
  }) {
    final center = Offset(size.width / 2, size.height); // Gauge center for calculations
    final radius = (size.width / 2) - strokeWidth / 2; // Arc's centerline radius
    final textRadius = radius + strokeWidth / 2 + 5; // Radius for label placement

    final anglePerUnit = pi / (maxValue - minValue); // Radians per unit

    List<Widget> labelWidgets = [];

    values.forEach((label, value) {
      final angle = pi - (value - minValue) * anglePerUnit; // Angle relative to positive X-axis, counter-clockwise from 0 to pi

      double labelX = center.dx + textRadius * cos(angle);
      double labelY = center.dy - textRadius * sin(angle); // Subtract for Y-axis going upwards

      TextAlign textAlign;
      if (value == minValue) { // 0 value on the left
        textAlign = TextAlign.start;
      } else if (value == maxValue) { // 300 value on the right
        textAlign = TextAlign.end;
      } else { // Middle values
        textAlign = TextAlign.center;
      }

      labelWidgets.add(
        Positioned(
          left: labelX,
          top: labelY - 10, // Adjust top to roughly center text vertically
          child: SizedBox(
            width: 40, // Small fixed width to help with alignment
            child: Text(
              label,
              textAlign: textAlign,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      );
    });
    return labelWidgets;
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final double strokeWidth;
  final Color greenColor;
  final Color goldenColor;
  final Color redColor;
  final Color indicatorColor;
  final Color trackColor;

  GaugePainter({
    required this.value,
    this.minValue = 0,
    this.maxValue = 300,
    this.strokeWidth = 40,
    required this.greenColor,
    required this.goldenColor,
    required this.redColor,
    required this.indicatorColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height); // Center at bottom middle of the CustomPaint widget
    final radius = (size.width / 2) - strokeWidth / 2; // Radius for the arc's center line

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Paint for the background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Draw background track (full 180-degree semi-circle)
    // Start at pi (left horizontal), sweep -pi (clockwise to right horizontal)
    canvas.drawArc(rect, pi, -pi, false, trackPaint);

    // Angle calculations (from pi to 0 radians, sweep negative clockwise)
    // 0 value corresponds to pi (180 deg)
    // 300 value corresponds to 0 (0 deg)
    final anglePerUnit = pi / (maxValue - minValue);

    // Green segment (0-100)
    final greenSweepAngle = (100 - minValue) * anglePerUnit;
    final greenPaint = Paint()
      ..color = greenColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, -greenSweepAngle, false, greenPaint); // Start at pi, sweep negative for clockwise

    // Golden segment (100-200)
    final goldenSweepAngle = (200 - 100) * anglePerUnit;
    final goldenPaint = Paint()
      ..color = goldenColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    // Start where green ends (pi - greenSweepAngle)
    canvas.drawArc(rect, pi - greenSweepAngle, -goldenSweepAngle, false, goldenPaint);

    // Red segment (200-300)
    final redSweepAngle = (maxValue - 200) * anglePerUnit;
    final redPaint = Paint()
      ..color = redColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    // Start where golden ends (pi - greenSweepAngle - goldenSweepAngle)
    canvas.drawArc(rect, pi - greenSweepAngle - goldenSweepAngle, -redSweepAngle, false, redPaint);

    // Indicator
    final indicatorAngle = pi - (value - minValue) * anglePerUnit; // Position of the value
    final indicatorPaint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Draw a small arc for the indicator around the calculated angle
    final indicatorStartAngle = indicatorAngle + (5 * pi / 180); // Start slightly clockwise from indicatorAngle (using negative sweep)
    final indicatorSweepAngle = -(10 * pi / 180); // 10 degrees total sweep for the indicator arc
    canvas.drawArc(rect, indicatorStartAngle, indicatorSweepAngle, false, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
           oldDelegate.greenColor != greenColor ||
           oldDelegate.goldenColor != goldenColor ||
           oldDelegate.redColor != redColor ||
           oldDelegate.indicatorColor != indicatorColor ||
           oldDelegate.trackColor != trackColor;
  }
}