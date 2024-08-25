import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSummaryService {
  static const String baseUrl = 'YOUR_API_BASE_URL';  // Replace with your actual API URL

  static Future<Map<String, dynamic>> fetchDailySummary(String token) async {
    const String apiUrl = '$baseUrl/daily_summary';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'totalTransactionValue': data['total_transaction_value'],
          'numberOfTransactions': data['number_of_transactions'],
          'totalProfits': data['total_profits'],
        };
      } else {
        throw Exception('Failed to load daily summary');
      }
    } catch (e) {
      print('Error fetching daily summary: $e');
      throw Exception('Failed to load daily summary');
    }
  }
}
