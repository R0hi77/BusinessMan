import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'saveInventory.dart';

class InventoryTable extends StatefulWidget {
 

  @override
  _InventoryTableState createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  final List<Map<String, dynamic>> _inventoryData = [];
  final Uuid _uuid = Uuid();

  List<Map<String, dynamic>> getInventoryData() {
    return List.from(_inventoryData);
  }

  
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
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: true,
              headingRowColor:
                  MaterialStateProperty.all(Color.fromARGB(249, 139, 245, 144)),
              columns: const [
                // DataColumn(label: Text('ID',
                //         style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 17)
                //         )
                //         ),

                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Category',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),
                DataColumn(
                    label: Text('Batch Number',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Order Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Reorder Level',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Cost Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Selling Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Expiry Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Supplier Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Supplier Contact',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),

                DataColumn(
                    label: Text('Actions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17))),
              ],
              rows: _inventoryData
                  .map((item) => DataRow(
                        cells: [
                          DataCell(TextFormField(
                            initialValue: item['name'] as String,
                            onChanged: (value) => _updateField(
                                item['id'] as String, 'name', value),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['category'] as String,
                            onChanged: (value) => _updateField(
                                item['id'] as String, 'category', value),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['quantity'].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'quantity',
                                int.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['batch_number'] as String,
                            onChanged: (value) => _updateField(
                                item['id'] as String, 'batch_number', value),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['order_quantity'].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'order_quantity',
                                int.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue:
                                item['reorder_level']?.toString() ?? '',
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'reorder_level',
                                int.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['cost_price'].toString(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'cost_price',
                                double.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['selling_price'].toString(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'selling_price',
                                double.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue: item['expiry_date'] != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(item['expiry_date'] as DateTime)
                                : '',
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'expiry_date',
                                DateTime.tryParse(value)),
                          )),
                          DataCell(TextFormField(
                            initialValue:
                                item['supplier_name'] as String? ?? '',
                            onChanged: (value) => _updateField(
                                item['id'] as String, 'supplier_name', value),
                          )),
                          DataCell(TextFormField(
                            initialValue:
                                item['supplier_contact'] as String? ?? '',
                            onChanged: (value) => _updateField(
                                item['id'] as String,
                                'supplier_contact',
                                value),
                          )),
                          DataCell(Row(children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteRow(item['id'] as String),
                            ),
                            IconButton(
                                onPressed: _addNewItem,
                                icon: const Icon(Icons.add))
                          ])),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: _addNewItem,
        //   child: const Text('Add New Item'),
        // ),

    const SizedBox(height:100),
         InkWell(
                    onTap: () {
                      saveInventoryData();
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(249, 139, 245, 144),
                      ),
                      child: const Center(
                        child: Text("Save All",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18)),
                      ),
                    ),
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

  Future<void> saveInventoryData() async {
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
