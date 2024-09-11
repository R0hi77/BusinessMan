import 'dart:convert';
import 'package:http/http.dart' as http;

// This function will send transaction details to the specified endpoint
Future<int> postTransactionData(Map<String, dynamic> transactionData, String jwtToken) async {
  var url = Uri.parse('http://localhost:5000/api/transaction/');

  var headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': 'Bearer $jwtToken',
  };

  var response = await http.post(
    url,
    body: jsonEncode(transactionData),
    headers: headers,
  );

  return response.statusCode;
}
