import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesBarChartNew extends StatefulWidget {
  final List<String> productNames;
  final List<int> salesNumbers;
  final double max;

  SalesBarChartNew({
    required this.productNames,
    required this.salesNumbers,
    required this.max,
  });

  @override
  _SalesBarChartState createState() => _SalesBarChartState();
}

class _SalesBarChartState extends State<SalesBarChartNew> {
  late List<String> _productNames;
  late List<int> _salesNumbers;
  late double _max;

  @override
  void initState() {
    super.initState();
    _productNames = widget.productNames;
    _salesNumbers = widget.salesNumbers;
    _max = widget.max;
  }

  void updateData(List<String> newProductNames, List<int> newSalesNumbers, double newMax) {
    setState(() {
      _productNames = newProductNames;
      _salesNumbers = newSalesNumbers;
      _max = newMax;
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
                if (index < 0 || index >= _productNames.length) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _productNames[index],
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
    return List.generate(_productNames.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _salesNumbers[index].toDouble(),
            color: Colors.red,
            width: 30,
            borderRadius: BorderRadius.circular(5),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _max,
              color: Colors.pink[50],
            ),
          ),
        ],
      );
    });
  }
}