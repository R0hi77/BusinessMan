import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchAccountDetails(String jwtToken) async {
  final String url = 'http://localhost:5000/api/profile/'; // Replace with your actual API URL

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful response, parse the JSON data
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      // Handle the case when the shop ID is not found in the token
      throw Exception('Shop ID not found in token');
    } else if (response.statusCode == 404) {
      // Handle the case when the shop is not found
      throw Exception('Shop not found');
    } else {
      // Handle other status codes
      throw Exception('Failed to load account details');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error: $e');
    throw Exception('Failed to fetch account details');
  }
}
