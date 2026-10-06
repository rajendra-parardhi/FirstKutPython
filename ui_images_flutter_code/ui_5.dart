import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirAware AI Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF1A1C22), // Main dark background
        fontFamily: 'Inter', // A modern sans-serif font
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF24272D), // Darker grey for cards
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero, // Custom margin for specific usage
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2E34), // Input field background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white54),
        ),
        // Custom colors for elements
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue;
            }
            return const Color(0xFF2A2E34);
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar (Control Panel)
          Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2127), // Slightly lighter than main background for sidebar
              borderRight: BorderSide(color: Colors.white10, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.red, Colors.orange, Colors.yellow],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.thermostat_outlined,
                        color: Colors.white, // This color is masked by the shader
                        size: 48,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.wb_sunny, color: Colors.amber, size: 32),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Control Panel', style: textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (bool? newValue) {},
                      activeColor: Colors.blueAccent,
                    ),
                    Text('Enable Admin Mode', style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 24),
                Text('Select City for Analytics', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: 'Ahmedabad',
                  decoration: const InputDecoration(
                    hintText: 'Select a city',
                  ),
                  dropdownColor: const Color(0xFF2A2E34),
                  style: textTheme.bodyLarge,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  onChanged: (String? newValue) {},
                  items: <String>['Ahmedabad', 'Delhi', 'Mumbai', 'Bangalore']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text('Select Date', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: '2015/02/26',
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white70),
                  ),
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 24),
                Text('Live Pollutant Levels', style: textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('PM2.5 (Fine Particles)', style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('78.07', style: textTheme.bodyLarge!.copyWith(color: Colors.redAccent)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.7807, // Example value
                        backgroundColor: const Color(0xFF3A3E45),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('PM10 (Dust)', style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('120.50', style: textTheme.bodyLarge!.copyWith(color: Colors.orangeAccent)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.40, // Example value
                        backgroundColor: const Color(0xFF3A3E45),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.cloud, color: Colors.blueGrey, size: 24),
                    const SizedBox(width: 8),
                    Text('28°C Mostly cloudy', style: textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ),

          // Right Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AirAware: Smart Air Quality Analytics',
                    style: textTheme.displayMedium!.copyWith(fontSize: 38, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dashboard Status: Active | Target City: Ahmedabad',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: Row(
                      children: [
                        // Live Prediction Visual Card (Gauge Chart)
                        Expanded(
                          flex: 5, // Wider than historical trends
                          child: Card(
                            margin: const EdgeInsets.only(right: 24),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Live Prediction Visual', style: textTheme.headlineSmall),
                                  const SizedBox(height: 24),
                                  Expanded(
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomPaint(
                                            painter: GaugePainter(value: 105),
                                            size: const Size(double.infinity, 250),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '105',
                                                style: textTheme.displayLarge!
                                                    .copyWith(fontSize: 64, color: Colors.white),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'MODERATE', // Example based on 105
                                                style: textTheme.titleLarge!.copyWith(color: Colors.orangeAccent),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Good', style: textTheme.bodyMedium!.copyWith(color: Colors.greenAccent)),
                                      Text('Moderate', style: textTheme.bodyMedium!.copyWith(color: Colors.orangeAccent)),
                                      Text('Poor', style: textTheme.bodyMedium!.copyWith(color: Colors.redAccent)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Historical Trends Card (Line Chart)
                        Expanded(
                          flex: 7, // Even wider
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Historical Trends: Ahmedabad', style: textTheme.headlineSmall),
                                  const SizedBox(height: 8),
                                  Text(
                                    'PM2.5 Levels over the last year',
                                    style: textTheme.bodyLarge!.copyWith(color: Colors.white60),
                                  ),
                                  const SizedBox(height: 24),
                                  Expanded(
                                    child: CustomPaint(
                                      painter: LineChartPainter(),
                                      size: const Size(double.infinity, double.infinity),
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}

// Custom Painter for the Gauge Chart
class GaugePainter extends CustomPainter {
  final double value;

  GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height); // Bottom center for semi-circle
    final radius = size.width / 2;
    const strokeWidth = 30.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background arc (for full range 0-300)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6, // Start angle (adjust for horizontal start)
      3.2, // Sweep angle for semi-circle
      false,
      paint..color = const Color(0xFF3A3E45),
    );

    // Segments based on example values (0-100 green, 100-200 gold, 200-300 red)
    final greenArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.greenAccent;
    final goldArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.orangeAccent;
    final redArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.redAccent;

    // Draw the active value indicator
    double normalizedValue = (value / 300).clamp(0.0, 1.0); // Assuming max 300 for gauge
    double sweepAngle = normalizedValue * 3.2; // Max sweep is 3.2 radians

    // Draw green segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6,
      (100 / 300) * 3.2,
      false,
      greenArcPaint,
    );
    // Draw gold segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6 + (100 / 300) * 3.2,
      (100 / 300) * 3.2,
      false,
      goldArcPaint,
    );
    // Draw red segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6 + (200 / 300) * 3.2,
      (100 / 300) * 3.2,
      false,
      redArcPaint,
    );


    // Draw current value indicator as a separate sweep over the segments
    // (This part ensures the active portion is visibly distinct if needed, but the image just has colored segments)
    // Here, we just highlight the segment based on the value.
    Paint activePaint;
    if (value <= 100) {
      activePaint = greenArcPaint;
    } else if (value <= 200) {
      activePaint = goldArcPaint;
    } else {
      activePaint = redArcPaint;
    }

    // You could also draw a small circle at the end of the current value
    // final double endAngle = -2.6 + sweepAngle;
    // final Offset indicatorPos = Offset(
    //   center.dx + radius * cos(endAngle),
    //   center.dy + radius * sin(endAngle),
    // );
    // canvas.drawCircle(indicatorPos, strokeWidth / 2, Paint()..color = Colors.white);

    // Labels around the gauge
    TextPainter(
      text: const TextSpan(text: '0', style: TextStyle(color: Colors.white70, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(center.dx - radius - 15, center.dy - 10)); // Leftmost

    TextPainter(
      text: const TextSpan(text: '100', style: TextStyle(color: Colors.white70, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(center.dx - radius * cos(0.8) - 15, center.dy - radius * sin(0.8) - 10));

    TextPainter(
      text: const TextSpan(text: '200', style: TextStyle(color: Colors.white70, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(center.dx + radius * cos(0.8) - 15, center.dy - radius * sin(0.8) - 10));


    TextPainter(
      text: const TextSpan(text: '300', style: TextStyle(color: Colors.white70, fontSize: 12)),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(center.dx + radius, center.dy - 10)); // Rightmost
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// Custom Painter for the Line Chart
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final gridPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw Y-axis labels and grid lines
    final List<int> yLabels = [200, 150, 100, 50, 0];
    final double yStep = size.height / (yLabels.length - 1); // 4 intervals for 5 labels

    for (int i = 0; i < yLabels.length; i++) {
      final double yPos = size.height - (i * yStep);
      final textPainter = TextPainter(
        text: TextSpan(
          text: yLabels[i].toString(),
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(-30, yPos - textPainter.height / 2)); // Position labels slightly left

      // Draw horizontal grid line
      if (yLabels[i] != 0) { // Don't draw grid line for 0 (x-axis)
        canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), gridPaint);
      }
    }

    // Placeholder data for the line chart
    final List<double> dataPoints = [
      50, 60, 40, 80, 100, 70, 90, 120, 150, 130, 110, 80, 60, 75, 95, 115, 135, 105, 85, 65,
      50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
      100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
    ];

    if (dataPoints.isEmpty) return;

    final Path path = Path();
    double startX = 0; // Padding for Y-axis labels is handled by the canvas offset in the main widget
    final double dataWidth = size.width / (dataPoints.length - 1);
    final double scaleY = size.height / 200; // Assuming max Y value is 200 based on the chart

    path.moveTo(startX, size.height - (dataPoints[0] * scaleY));

    for (int i = 1; i < dataPoints.length; i++) {
      path.lineTo(startX + (i * dataWidth), size.height - (dataPoints[i] * scaleY));
    }
    canvas.drawPath(path, paint);

    // Draw X-axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), gridPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // Repaint only if data changes
}