import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailySalesTrendChart extends StatelessWidget {
  DailySalesTrendChart({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> staticData = [
    {"hour": 0, "sales": 25},
    {"hour": 1, "sales": 30},
    {"hour": 2, "sales": 22},
    {"hour": 3, "sales": 20},
    {"hour": 4, "sales": 35},
    {"hour": 5, "sales": 50},
    {"hour": 6, "sales": 70},
    {"hour": 7, "sales": 90},
    {"hour": 8, "sales": 110},
    {"hour": 9, "sales": 130},
    {"hour": 10, "sales": 150},
    {"hour": 11, "sales": 170},
    {"hour": 12, "sales": 180},
    {"hour": 13, "sales": 165},
    {"hour": 14, "sales": 155},
    {"hour": 15, "sales": 140},
    {"hour": 16, "sales": 130},
    {"hour": 17, "sales": 145},
    {"hour": 18, "sales": 160},
    {"hour": 19, "sales": 170},
    {"hour": 20, "sales": 155},
    {"hour": 21, "sales": 140},
    {"hour": 22, "sales": 120},
    {"hour": 23, "sales": 95},
  ];

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = staticData
        .map((data) => FlSpot(data["hour"].toDouble(), data["sales"].toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}:00',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                );
              },
              interval: 4,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₵${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              interval: 40,
              reservedSize: 40,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 23,
        minY: 20,
        maxY: 180,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}