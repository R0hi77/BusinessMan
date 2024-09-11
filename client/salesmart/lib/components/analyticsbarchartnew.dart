import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesBarChart extends StatefulWidget {
  final List<String> initialProductNames;
  final List<int> initialSalesNumbers;
  final double initialMax;

  SalesBarChart({
    required this.initialProductNames,
    required this.initialSalesNumbers,
    required this.initialMax,
  });

  @override
  _SalesBarChartState createState() => _SalesBarChartState();
}

class _SalesBarChartState extends State<SalesBarChart> {
  late List<String> productNames;
  late List<int> salesNumbers;
  late double max;

  @override
  void initState() {
    super.initState();
    productNames = widget.initialProductNames;
    salesNumbers = widget.initialSalesNumbers;
    max = widget.initialMax;
  }

  void updateData(List<String> newProductNames, List<int> newSalesNumbers, double newMax) {
    setState(() {
      productNames = newProductNames;
      salesNumbers = newSalesNumbers;
      max = newMax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        barGroups: _buildBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= productNames.length) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    productNames[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(productNames.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: salesNumbers[index].toDouble(),
            color: Colors.red,
            width: 30,
            borderRadius: BorderRadius.circular(5),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: max,
              color: Colors.pink[50],
            ),
          ),
        ],
      );
    });
  }
}