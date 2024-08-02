import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryService {
  Future<void> saveInventoryData(List<Map<String, dynamic>> inventoryData) async {
    // Print to console for demonstration
    print(json.encode(inventoryData));

    // Example of how you might send this to an API:
    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/inventory'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(inventoryData),
      );
      if (response.statusCode == 200) {
        print('Data saved successfully');
      } else {
        print('Failed to save data');
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}