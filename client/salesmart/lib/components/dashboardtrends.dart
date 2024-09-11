import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesTrendsChart extends StatelessWidget {
  final List<FlSpot> salesData;

  // Constructor to accept sales data
  SalesTrendsChart({required this.salesData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) {
              return Text('${value.toInt()} GHS', style: TextStyle(fontSize: 10));
            }),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (value, meta) {
              return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
            }),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 1,
        maxX: 31,
        minY: 0,
        maxY: 50000,
        lineBarsData: [
          LineChartBarData(
            spots: salesData,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
