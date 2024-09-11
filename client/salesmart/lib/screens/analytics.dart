import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/metricCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salesmart/components/analyticsbarchartnew.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:salesmart/components/salestrend.dart';

class AnalyticsPage extends StatefulWidget {
  final String token;

  AnalyticsPage({super.key,required this.token});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _dropdownvalue = 'Daily';
  final _items = ['Daily', 'Weekly', 'Monthly', 'Year'];
  List<String> _productNames = [];
  List<int> _salesNumbers = [];
  double _max = 0;

  String _dropdownvaluetrends = 'Daily';
  final _itemtrends = ['Daily', 'Weekly', 'Monthly', 'Year'];
  List<FlSpot> _salesTrendData = [];
  double _maxSales = 0;

  // New state variables for metric data
  int _transactionsCount = 0;
  double _transactionsValue = 0.0;
  double _profits = 0.0;

  @override
  void initState() {
    super.initState();
    fetchMetricData();
    fetchGraphData(_dropdownvalue);
    fetchTrendData(_dropdownvaluetrends);
  }

  Future<void> fetchMetricData() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/analytics/daily_summary'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _transactionsCount = data['transactionsCount'];
        _transactionsValue = data['transactionsValue'].toDouble();
        _profits = data['profits'].toDouble();
      });
    } else {
      print('Failed to fetch metric data');
    }
  }

  Future<void> fetchTrendData(String selectedValue) async {
  final response = await http.get(
    Uri.parse('https://your-api.com/api/analytics/sales_trend/$selectedValue'),
     headers: {'Authorization': 'Bearer ${widget.token}'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      _salesTrendData = List<FlSpot>.from(data['salesTrend'].map(
          (point) => FlSpot(point['x'].toDouble(), point['y'].toDouble())));
      _maxSales = data['maxSales'].toDouble();
    });
  } else {
    print('Failed to fetch trend data');
  }
}

Future<void> fetchGraphData(String selectedValue) async {
  final response = await http.get(
    Uri.parse('https://localhost:5000/api/analytics/top_products/$selectedValue'),
    headers: {'Authorization': 'Bearer ${widget.token}'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      _productNames = List<String>.from(data['productNames']);
      _salesNumbers = List<int>.from(data['salesNumbers']);
      _max = data['max'].toDouble();
    });
  } else {
    print('Failed to fetch graph data');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.arrow_left,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text("SaleSmart",
                style: GoogleFonts.archivoBlack(
                    textStyle:
                        const TextStyle(fontSize: 30, color: Colors.black)))
          ],
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
              color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MetricCard(
                    icon: const Icon(Icons.monetization_on),
                    title: "Transactions Value",
                    value: "GH₵${_transactionsValue.toStringAsFixed(2)}",
                    color: const Color.fromARGB(251, 250, 206, 210),
                    width: 300,
                  ),
                  MetricCard(
                    icon: const Icon(Icons.monetization_on),
                    title: "Profits",
                    value: "GH₵${_profits.toStringAsFixed(2)}",
                    color: const Color.fromARGB(253, 255, 241, 150),
                    width: 300,
                  ),
                  MetricCard(
                    icon: const Icon(Icons.shopping_cart),
                    title: "Number of Transactions",
                    value: _transactionsCount.toString(),
                    color: const Color.fromARGB(250, 141, 255, 189),
                    width: 300,
                  ),
                  MetricCard(
                    icon: const Icon(Icons.monetization_on),
                    title: "Profits",
                    value: "GH₵....",
                    color: const Color.fromARGB(253, 200, 244, 249),
                    width: 300,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 60, 0, 60),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xffEBEDFE),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          underline: Container(
                            width: 2,
                            height: 2,
                          ),
                          dropdownColor: const Color(0xffEBEDFE),
                          items: _items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownvalue = newValue.toString();
                            });
                            if (newValue != null) {
                              fetchGraphData(newValue);
                            }
                          },
                          value: _dropdownvalue,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_productNames.isNotEmpty)
                  Container(
                    width: MediaQuery.sizeOf(context).height * 0.8,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: SalesBarChart(
                      initialProductNames: _productNames,
                      initialSalesNumbers: _salesNumbers,
                      initialMax: _max,
                    ),
                  )
                else if (_dropdownvalue != null)
                  const SizedBox(
                    width: 15,
                  ),
                const CircularProgressIndicator(
                  color: Colors.green,
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 60, 0, 60),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xffEBEDFE),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          underline: Container(
                            width: 2,
                            height: 2,
                          ),
                          dropdownColor: const Color(0xffEBEDFE),
                          items: _itemtrends.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownvaluetrends = newValue.toString();
                            });
                            if (newValue != null) {
                              fetchTrendData(newValue);
                            }
                          },
                          value: _dropdownvaluetrends,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_productNames.isNotEmpty)
                  Container(
                    width: MediaQuery.sizeOf(context).height * 0.8,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: SalesTrendChart(
                      dataPoints: _salesTrendData,
                      maxY: _maxSales,
                    ),
                  )
                else if (_dropdownvaluetrends != null)
                  const SizedBox(
                    width: 15,
                  ),
                const CircularProgressIndicator(
                  color: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}