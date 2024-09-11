import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProfileService {
  static const String baseUrl = 'http://localhost:5000/api/profile';  // Replace with your actual API URL

  static Future<Map<String, dynamic>> fetchShopDetails(String token) async {
    const String apiUrl = '$baseUrl/manager';

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
          'shopName': data['shop_name'],
        };
      } else if (response.statusCode == 400) {
        return {
          'error': 'Shop details not found',
        };
      } else {
        throw Exception('Failed to load shop details');
      }
    } catch (e) {
      print('Error fetching shop details: $e');
      throw Exception('Failed to load shop details');
    }
  }
}