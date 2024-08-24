import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'YOUR_API_BASE_URL';  // Replace with your actual API URL

  static Future<Map<String, dynamic>> fetchTopProducts(String timePeriod, String token) async {
    final String apiUrl = '$baseUrl/top_products';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'time_period': timePeriod,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Sort the data by total_quantity in descending order and take top 5
        data.sort((a, b) => b['total_quantity'].compareTo(a['total_quantity']));
        final topFiveData = data.take(5).toList();

        final List<String> productNames = topFiveData.map((item) => item['product_name'] as String).toList();
        final List<int> salesNumbers = topFiveData.map((item) => item['total_quantity'] as int).toList();
        final double maxValue = salesNumbers.reduce((max, value) => value > max ? value : max).toDouble() + 10;

        return {
          'productNames': productNames,
          'salesNumbers': salesNumbers,
          'max': maxValue,
        };
      } else {
        throw Exception('Failed to load top products');
      }
    } catch (e) {
      print('Error fetching top products: $e');
      throw Exception('Failed to load top products');
    }
  }
}