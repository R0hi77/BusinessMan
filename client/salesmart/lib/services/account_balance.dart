// lib/services/paystack_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaystackService {
  static Future<Map<String, dynamic>> fetchBalance() async {
    try {
      await dotenv.load(fileName: "/home/petersburg/Desktop/BusinessManager/.env");
      final String? apiKey = dotenv.env['PAYSTACK_KEY'];

      if (apiKey == null) {
        throw Exception('Paystack API key not found');
      }

      final response = await http.get(
        Uri.parse('https://api.paystack.co/balance'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == true && data['data'] is List && data['data'].isNotEmpty) {
          return data['data'][0];  // Return the first item in the data array
        } else {
          throw Exception('Failed to load balance: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load balance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Paystack balance: $e');
      throw Exception('Error fetching Paystack balance');
    }
  }
}