import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Distribution',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Use Roboto for a modern look
      ),
      home: const SentimentChartScreen(),
    );
  }
}

class SentimentChartScreen extends StatelessWidget {
  const SentimentChartScreen({super.key});

  final double _maxValue = 45000.0;
  final double _chartHeight = 250.0; // Visual height for the bars themselves (0 to 45000)
  final double _xAxisLabelHeight = 22.0; // Space for X-axis labels + padding

  // Helper widget to build individual bar columns
  Widget _buildBarColumn(int value, String label, Color color) {
    final barHeight = (value / _maxValue) * _chartHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Align contents to the bottom
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5), // Spacing between value and bar
        Container(
          width: 40, // Bar width
          height: barHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)), // Slightly rounded top corners
            border: Border.all(color: Colors.black, width: 1), // Black border
          ),
        ),
        const SizedBox(height: 5), // Spacing between bar and label
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
        ),
      ],
    );
  }

  // Helper widget to build legend items
  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.black, width: 1),
          ),
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart Title
                const Text(
                  'TextBlob Sentiment Distribution',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),

                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('TextBlob Positive', const Color(0xFF009587)),
                    const SizedBox(width: 20),
                    _buildLegendItem('TextBlob Negative', const Color(0xFFB41B1B)),
                    const SizedBox(width: 20),
                    _buildLegendItem('TextBlob Neutral', const Color(0xFFC1C1C1)),
                  ],
                ),
                const SizedBox(height: 25),

                // Chart Area (Y-axis, Grid lines, Bars)
                SizedBox(
                  height: _chartHeight + _xAxisLabelHeight, // Total height for bars + x-axis labels
                  child: Stack(
                    children: [
                      // 'Count' Label on Y-axis
                      Positioned(
                        left: 0,
                        top: (_chartHeight + _xAxisLabelHeight) / 2 - 20, // Center vertically roughly
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Count',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),

                      // Y-Axis numbers and horizontal grid lines
                      Positioned(
                        left: 40, // Space for 'Count' label
                        right: 0,
                        bottom: _xAxisLabelHeight, // Space for X-axis labels below bars
                        top: 0,
                        child: Stack(
                          children: [
                            // Y-axis horizontal grid lines
                            ...List.generate(5, (index) {
                              final value = index * 10000;
                              final lineBottom = (value / _maxValue) * _chartHeight;
                              return Positioned(
                                bottom: lineBottom,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 1,
                                  color: Colors.grey[200], // Lighter grey for grid lines
                                ),
                              );
                            }),
                            // Y-axis numeric labels
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(5, (index) {
                                  final value = index * 10000;
                                  return Text(
                                    '$value',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  );
                                }).reversed.toList(), // 40000 at top, 0 at bottom
                              ),
                            ),
                            // X-axis baseline (0 line)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(height: 1, color: Colors.grey[400]),
                            ),
                            // Y-axis vertical line (leftmost of plotting area)
                            Positioned(
                              bottom: 0,
                              top: 0,
                              left: 0,
                              child: Container(width: 1, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),

                      // Bars and X-axis labels
                      Positioned(
                        left: 80, // Space for 'Count' and Y-axis numbers
                        right: 0,
                        bottom: 0, // Align bars' base at the bottom of the Stack
                        top: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end, // Align bars to bottom
                          children: [
                            _buildBarColumn(45000, 'Positive', const Color(0xFF009587)),
                            _buildBarColumn(25000, 'Negative', const Color(0xFFB41B1B)),
                            _buildBarColumn(30000, 'Neutral', const Color(0xFFC1C1C1)),
                          ],
                        ),
                      ),
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
}