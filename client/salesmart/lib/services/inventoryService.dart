import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryService {
  final String baseUrl = 'https://yourapi.com'; // Replace with your actual API base URL

  Future<Map<String, dynamic>?> getInventoryItemById(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        print('No inventory item with ID $id found');
        return null;
      } else {
        print('Failed to load inventory item: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getInventoryList(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inventory/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> inventoryList = json.decode(response.body);
        return inventoryList.map((item) => item as Map<String, dynamic>).toList();
      } else if (response.statusCode == 404) {
        print('No stock added yet');
        return null;
      } else {
        print('Failed to load inventory list: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> addInventoryItem(Map<String, dynamic> item, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inventory/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(item),
      );
      if (response.statusCode == 201) {
        print('Inventory item added successfully');
        return true;
      } else {
        print('Failed to add inventory item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding inventory item: $e');
      return false;
    }
  }

  Future<bool> updateInventoryItem(Map<String, dynamic> item, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/inventory/${item['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(item),
      );
      if (response.statusCode == 200) {
        print('Inventory item updated successfully');
        return true;
      } else {
        print('Failed to update inventory item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating inventory item: $e');
      return false;
    }
  }

  Future<bool> deleteInventoryItem(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/inventory/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print('Inventory item deleted successfully');
        return true;
      } else {
        print('Failed to delete inventory item: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting inventory item: $e');
      return false;
    }
  }
}