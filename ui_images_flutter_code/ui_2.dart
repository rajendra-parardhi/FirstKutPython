import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pollutant Impact Score',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // A common modern sans-serif font
      ),
      home: const PollutantChartPage(),
    );
  }
}

class PollutantChartPage extends StatelessWidget {
  const PollutantChartPage({super.key});

  // Data for the pollutants, their scores, and corresponding colors
  final List<Map<String, dynamic>> pollutantData = const [
    {"name": "PM2.5", "score": 45.0},
    {"name": "PM10", "score": 27.0},
    {"name": "CO", "score": 15.0},
    {"name": "NO2", "score": 12.0},
    {"name": "SO2", "score": 7.0},
    {"name": "O3", "score": 5.0},
    {"name": "Benzene", "score": 3.0},
    {"name": "Month", "score": 1.5},
    {"name": "NH3", "score": 1.5},
    {"name": "Xylene", "score": 0.5},
  ];

  // Define a color map for the bar chart and legend based on score ranges
  Color getColorForScore(double score) {
    if (score >= 40) return const Color(0xFFFFD700); // Yellow
    if (score >= 25) return const Color(0xFF00BFA5); // Teal
    if (score >= 15) return const Color(0xFF305f86); // Dark Blue
    if (score >= 10) return const Color(0xFF3a5089); // Indigo Blue
    if (score >= 6) return const Color(0xFF452f7b); // Purple
    if (score >= 4) return const Color(0xFF45206e); // Darker Purple
    if (score >= 2) return const Color(0xFF451062); // Even Darker Purple
    if (score >= 1) return const Color(0xFF44095a); // Very Dark Purple
    return const Color(0xFF3F0052); // Extremely Dark Purple (for Xylene, lowest scores)
  }

  // Define colors for the legend gradient stops
  final List<Color> legendGradientColors = const [
    Color(0xFFFFD700), // Yellow (for ~45/40)
    Color(0xFF66BB6A), // Green (for ~30)
    Color(0xFF00ACC1), // Cyan (for ~20)
    Color(0xFF3F51B5), // Indigo (for ~10)
    Color(0xFF3F0052), // Extremely Dark Purple (for ~0)
  ];

  final double maxImpactScore = 45.0; // Max score for scaling bars

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e2321), // Dark background color
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          width: 900, // Fixed width for the chart container
          height: 500, // Fixed height
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section: Pollutant Labels
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const RotatedBox(
                      quarterTurns: -1,
                      child: Text(
                        'Pollutant',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Adjust spacing
                    ...pollutantData.map((data) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: Text(
                            data["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              // Middle Section: Bar Chart
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40), // Spacing for chart top
                    // Bars
                    ...pollutantData.map((data) {
                      double barWidth =
                          (data["score"] / maxImpactScore) * 600; // Scale bar width
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Row(
                          children: [
                            Container(
                              width: barWidth,
                              height: 20,
                              decoration: BoxDecoration(
                                color: getColorForScore(data["score"]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const Spacer(), // Pushes X-axis to bottom
                    // X-axis numbers
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          10, // For 0, 5, 10, ..., 45
                          (index) => Text(
                            (index * 5).toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        )..add(const Text('45', style: TextStyle(color: Colors.white70, fontSize: 12))),
                      ),
                    ),
                    // X-axis label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Impact Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right Section: Color Legend
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Impact Score',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          width: 20,
                          height: 200, // Height of the legend bar
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: legendGradientColors,
                              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -8, // Adjust to align with color bar
                          right: 28,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('40', style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(height: 38), // Adjust spacing
                              Text('30', style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(height: 38),
                              Text('20', style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(height: 38),
                              Text('10', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
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
      ),
    );
  }
}