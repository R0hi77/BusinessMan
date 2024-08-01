import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryTable extends StatefulWidget {
  const InventoryTable({Key? key}) : super(key: key);

  @override
  _InventoryTableState createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  final List<Map<String, dynamic>> _inventoryData = [];
  final Uuid _uuid = Uuid();
  
  @override
  void initState() {
    super.initState();
    _addNewItem(); // Add a sample item
  }

  void _addNewItem() {
    final newItem = {
      'id': _uuid.v4(),
      'name': '',
      'category': '',
      'quantity': 0,
      'batch_number': '',
      'order_quantity': 0,
      'reorder_level': null,
      'cost_price': 0.0,
      'selling_price': 0.0,
      'expiry_date': null,
      'supplier_name': null,
      'supplier_contact': null,
    };
    setState(() {
      _inventoryData.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Batch Number')),
                DataColumn(label: Text('Order Quantity')),
                DataColumn(label: Text('Reorder Level')),
                DataColumn(label: Text('Cost Price')),
                DataColumn(label: Text('Selling Price')),
                DataColumn(label: Text('Expiry Date')),
                DataColumn(label: Text('Supplier Name')),
                DataColumn(label: Text('Supplier Contact')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _inventoryData.map((item) => DataRow(
                cells: [
                  DataCell(TextFormField(
                    initialValue: item['name'] as String,
                    onChanged: (value) => _updateField(item['id'] as String, 'name', value),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['category'] as String,
                    onChanged: (value) => _updateField(item['id'] as String, 'category', value),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['quantity'].toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateField(item['id'] as String, 'quantity', int.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['batch_number'] as String,
                    onChanged: (value) => _updateField(item['id'] as String, 'batch_number', value),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['order_quantity'].toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateField(item['id'] as String, 'order_quantity', int.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['reorder_level']?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateField(item['id'] as String, 'reorder_level', int.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['cost_price'].toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _updateField(item['id'] as String, 'cost_price', double.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['selling_price'].toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => _updateField(item['id'] as String, 'selling_price', double.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['expiry_date'] != null 
                      ? DateFormat('yyyy-MM-dd').format(item['expiry_date'] as DateTime)
                      : '',
                    onChanged: (value) => _updateField(item['id'] as String, 'expiry_date', DateTime.tryParse(value)),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['supplier_name'] as String? ?? '',
                    onChanged: (value) => _updateField(item['id'] as String, 'supplier_name', value),
                  )),
                  DataCell(TextFormField(
                    initialValue: item['supplier_contact'] as String? ?? '',
                    onChanged: (value) => _updateField(item['id'] as String, 'supplier_contact', value),
                  )),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteRow(item['id'] as String),
                  )),
                ],
              )).toList(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _addNewItem,
          child: const Text('Add New Item'),
        ),
        ElevatedButton(
          onPressed: _saveInventoryData,
          child: const Text('Save All Data'),
        ),
      ],
    );
  }

  void _updateField(String id, String field, dynamic value) {
    setState(() {
      final index = _inventoryData.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _inventoryData[index][field] = value;
      }
    });
  }

  void _deleteRow(String id) {
    setState(() {
      _inventoryData.removeWhere((item) => item['id'] == id);
    });
  }

  Future<void> _saveInventoryData() async {
    // This is where you would typically send the data to your API
    // For demonstration, we'll just print it to the console
    print(json.encode(_inventoryData));

    // Example of how you might send this to an API:
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://your-api-endpoint.com/inventory'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: json.encode(_inventoryData),
    //   );
    //   if (response.statusCode == 200) {
    //     print('Data saved successfully');
    //   } else {
    //     print('Failed to save data');
    //   }
    // } catch (e) {
    //   print('Error saving data: $e');
    // }
  }
}