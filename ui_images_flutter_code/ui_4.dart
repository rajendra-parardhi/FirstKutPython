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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Ensure Roboto font is available in pubspec.yaml
      ),
      home: const AirAwareDashboard(),
    );
  }
}

class AppColors {
  static const Color backgroundColor = Color(0xFF1A1D21);
  static const Color cardBackgroundColor = Color(0xFF222830);
  static const Color textColor = Color(0xFFE0E0E0);
  static const Color subtleTextColor = Color(0xFFA0A0A0);
  static const Color inputBackgroundColor = Color(0xFF313840);
  static const Color borderColor = Color(0xFF3E444B);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color pm25RedBar = Color(0xFFEF5350);
}

class AirAwareDashboard extends StatefulWidget {
  const AirAwareDashboard({super.key});

  @override
  State<AirAwareDashboard> createState() => _AirAwareDashboardState();
}

class _AirAwareDashboardState extends State<AirAwareDashboard> {
  bool _isAdminMode = false;
  String _selectedCity = 'Ahmedabad';
  String _selectedDate = '2015/02/26';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 380, // Adjusted width based on screenshot
      color: AppColors.cardBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildControlPanel(),
          const SizedBox(height: 15),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 15),
          _buildSelectGroup(
            label: 'Select City for Analytics',
            child: DropdownButtonFormField<String>(
              value: _selectedCity,
              dropdownColor: AppColors.inputBackgroundColor,
              decoration: _inputDecoration(),
              items: <String>['Ahmedabad', 'Mumbai', 'Delhi']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: AppColors.textColor)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
              style: const TextStyle(color: AppColors.textColor, fontSize: 15),
            ),
          ),
          const SizedBox(height: 20),
          _buildSelectGroup(
            label: 'Select Date',
            child: TextField(
              controller: TextEditingController(text: _selectedDate),
              readOnly: true,
              style: const TextStyle(color: AppColors.textColor, fontSize: 15),
              decoration: _inputDecoration().copyWith(
                suffixIcon: const Icon(Icons.calendar_today, color: AppColors.subtleTextColor, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 15),
          _buildPollutantLevels(),
          const Spacer(), // Pushes weather info to the bottom
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 15),
          _buildWeatherInfo(),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
      ),
      hoverColor: Colors.transparent, // Disable hover effect
    );
  }

  Widget _buildControlPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.thermostat_outlined, color: AppColors.accentOrange, size: 30),
                Positioned(
                  top: -8,
                  right: -8,
                  child: Icon(Icons.wb_sunny, color: AppColors.accentOrange.withOpacity(0.8), size: 20),
                ),
              ],
            ),
            const SizedBox(width: 15),
            const Text(
              'Control Panel',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: _isAdminMode,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isAdminMode = newValue!;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.accentBlue;
                  }
                  return AppColors.inputBackgroundColor;
                }),
                side: const BorderSide(color: AppColors.borderColor, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Enable Admin Mode',
              style: TextStyle(
                color: AppColors.subtleTextColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildPollutantLevels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Live Pollutant Levels',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        _buildPollutantItem('PM2.5 (Fine Particles)', '78.07', 0.78, AppColors.pm25RedBar),
        _buildPollutantItem('PM10 (Dust)', '120.15', 0.85, AppColors.accentOrange), // Assuming PM10 is orange
      ],
    );
  }

  Widget _buildPollutantItem(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.subtleTextColor, fontSize: 15),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.inputBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Row(
      children: [
        const Icon(Icons.cloud_outlined, color: AppColors.accentBlue, size: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '28°C',
              style: TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              'Mostly cloudy',
              style: TextStyle(color: AppColors.subtleTextColor, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainHeader(),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1, // Adjusted flex for better distribution
                  child: _buildLivePredictionCard(),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 2, // Adjusted flex for better distribution
                  child: _buildHistoricalTrendsCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'AirAware: Smart Air Quality Analytics',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Text(
              'Dashboard Status: ',
              style: TextStyle(color: AppColors.subtleTextColor, fontSize: 15),
            ),
            Text(
              'Active',
              style: TextStyle(color: AppColors.accentGreen, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              ' | Target City: ',
              style: TextStyle(color: AppColors.subtleTextColor, fontSize: 15),
            ),
            Text(
              'Ahmedabad',
              style: TextStyle(color: AppColors.textColor, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackgroundColor,
                foregroundColor: AppColors.textColor,
                side: const BorderSide(color: AppColors.borderColor),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              child: const Text('Deploy'),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.more_vert, color: AppColors.subtleTextColor),
          ],
        ),
      ],
    );
  }

  Widget _buildLivePredictionCard() {
    return _buildDashboardCard(
      title: 'Live Prediction Visual',
      child: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: GaugePainter(
                  value: 105,
                  maxValue: 300,
                  segments: [
                    GaugeSegment(0, 100, AppColors.accentGreen),
                    GaugeSegment(100, 200, AppColors.accentOrange),
                    GaugeSegment(200, 300, AppColors.accentRed),
                  ],
                ),
                child: Container(),
              ),
              Positioned(
                bottom: 50, // Adjust position to center vertically within semicircle
                child: Text(
                  '105',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 60,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 25,
                child: Text('100', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
              ),
              Positioned(
                top: -5,
                left: 140,
                child: Text('200', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
              ),
              Positioned(
                top: 0,
                right: 25,
                child: Text('300', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricalTrendsCard() {
    return _buildDashboardCard(
      title: 'Historical Trends: Ahmedabad',
      subtitle: 'PM2.5 Levels over the last year',
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 20.0), // Padding for chart content
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end, // Align y-axis labels and chart bottom
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('200', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
                Text('150', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
                Text('100', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
                Text('50', style: TextStyle(color: AppColors.subtleTextColor, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomPaint(
                painter: LineChartPainter(),
                child: Container(
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({required String title, String? subtitle, required Widget child}) {
    return Card(
      color: AppColors.cardBackgroundColor,
      elevation: 0, // Remove default elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.subtleTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the Gauge Chart
class GaugeSegment {
  final double startValue;
  final double endValue;
  final Color color;

  GaugeSegment(this.startValue, this.endValue, this.color);
}

class GaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final List<GaugeSegment> segments;

  GaugePainter({
    required this.value,
    required this.maxValue,
    required this.segments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    const strokeWidth = 30.0; // Thickness of the gauge band

    final backgroundArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw segments
    for (var segment in segments) {
      final startAngle = -180 * (segment.startValue / maxValue) * (pi / 180) + pi;
      final endAngle = -180 * (segment.endValue / maxValue) * (pi / 180) + pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        backgroundArcPaint..color = segment.color,
      );
    }

    // Draw the inner circle to create the "hollow" effect
    final innerCirclePaint = Paint()..color = AppColors.cardBackgroundColor;
    canvas.drawCircle(center, radius - strokeWidth, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for the Line Chart (Simplified representation)
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.accentBlue // Blue line color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gridPaint = Paint()
      ..color = AppColors.borderColor.withOpacity(0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    final numLines = 4; // for 50, 100, 150, 200
    for (int i = 0; i <= numLines; i++) {
      final y = size.height - (i / numLines * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), gridPaint);


    // Simplified path for the line chart (mimicking the screenshot)
    final path = Path();
    path.moveTo(0, size.height * 0.75); // Start bottom-left-ish
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.15, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.25, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.5, size.width * 0.35, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.45, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.6, size.width * 0.55, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.65, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.3, size.width * 0.75, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width * 0.85, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.1, size.width * 0.95, size.height * 0.05);
    path.quadraticBezierTo(size.width * 1.0, size.height * 0.1, size.width * 1.0, size.height * 0.2); // End around mid-right

    // Scale path vertically to fit the "PM2.5 Levels over the last year" visual
    final Matrix4 matrix = Matrix4.identity();
    matrix.translate(0.0, size.height * 0.25); // Move origin down
    matrix.scale(1.0, 0.75); // Scale to 75% of height to match visual compression
    path.transform(matrix.storage);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}