import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class ApiTrendService {
  static const String baseUrl = 'YOUR_API_BASE_URL';  // Replace with your actual API URL

  // ... other methods ...

  static Future<Map<String, dynamic>> fetchDailySales(String token) async {
    const  String apiUrl = '$baseUrl/sales_daily';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<FlSpot> dataPoints = data.map((item) {
          return FlSpot(item['x'].toDouble(), item['y'].toDouble());
        }).toList();

        double maxY = data.isEmpty ? 0 : data.map((item) => item['y'] as num).reduce((a, b) => a > b ? a : b).toDouble();

        return {
          'dataPoints': dataPoints,
          'maxY': maxY,
        };
      } else {
        throw Exception('Failed to load daily sales data');
      }
    } catch (e) {
      print('Error fetching daily sales data: $e');
      throw Exception('Failed to load daily sales data');
    }
  }
}