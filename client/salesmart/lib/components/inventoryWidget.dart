import 'package:flutter/material.dart';
import 'package:salesmart/services/inventoryService.dart';
import 'package:salesmart/models/inventoryCategory.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding JSON data


class InventoryTable extends StatefulWidget {
  final Function(String) onAddToCart;
  final String searchQuery;
  final String token;

  const InventoryTable({
    Key? key,
    required this.onAddToCart,
    required this.searchQuery,
    required this.token,
  }) : super(key: key);

  @override
  InventoryTableState createState() => InventoryTableState();
}

class InventoryTableState extends State<InventoryTable> {
  final InventoryService _inventoryService = InventoryService();
  List<Map<String, dynamic>> inventoryItems = [];
  Map<String, dynamic>? editingItem;

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  Future<void> saveAllItems(String token) async {
    // Logic to save all items to the backend using the inventoryService
    List<Map<String, dynamic>> items = inventoryItems; // Assuming inventoryItems is your list of items to save

    // Define the API endpoint
    String url = 'http://localhost:5000/api/inventory';

    // Iterate over each item and send a POST request
    for (var item in items) {
      try {
        // Create the request payload
        Map<String, dynamic> payload = {
          'name': item['name'],
          'category': item['category'],
          'price': item['price'],
          'quantity': item['quantity'],
          'expiryDate': item['expiryDate'],
          'supplier': item['supplier'],
          'barcode': item['barcode'],
        };

        // Send the POST request
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Include the token for authentication if required
          },
          body: jsonEncode(payload), // Convert the payload to a JSON string
        );

        // Check the response status
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Item saved successfully
          print('Item saved: ${item['name']}');
        } else {
          // Handle errors
          print('Failed to save item: ${item['name']}. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        // Handle exceptions (e.g., network errors)
        print('Error saving item: ${item['name']}. Error: $e');
      }
    }
  }

  Future<void> _loadInventoryItems() async {
    final items = await _inventoryService.getInventoryList(widget.token);
    setState(() {
      inventoryItems = items ?? [];
    });
  }

  void _addNewItem() {
    setState(() {
      final uuid = Uuid(); // Create a UUID object
      final newItem = {
        'id': uuid.v4(), // Generate a UUID v4
        'name': '',
        'category': '',
        'price': 0.0,
        'quantity': 0,
        'expiryDate': '',
        'supplier': '',
        'barcode': '',
      };
      inventoryItems.add(newItem);
      editingItem = newItem;
    });
  }

  void _editItem(Map<String, dynamic> item) {
    setState(() {
      editingItem = Map.from(item);
      if (editingItem!['category'] is String) {
        editingItem!['category'] = ItemCategoryExtension.fromString(editingItem!['category']);
      }
    });
  }

  void _saveItem() async {
    if (editingItem != null) {
      final index = inventoryItems.indexWhere((item) => item['id'] == editingItem!['id']);
      if (index != -1) {
        setState(() {
          inventoryItems[index] = editingItem!;
        });
        await _inventoryService.updateInventoryItem(editingItem!, widget.token);
      } else {
        setState(() {
          inventoryItems.add(editingItem!);
        });
        await _inventoryService.addInventoryItem(editingItem!, widget.token);
      }
      setState(() {
        editingItem = null;
      });
    }
  }

  void _deleteItem(Map<String, dynamic> item) async {
    setState(() {
      inventoryItems.removeWhere((element) => element['id'] == item['id']);
    });
    await _inventoryService.deleteInventoryItem(item['id'], widget.token);
  }

  DataCell _buildEditableCell(Map<String, dynamic> item, String key) {
    return DataCell(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: editingItem != null && editingItem!['id'] == item['id']
            ? TextFormField(
                initialValue: editingItem![key]?.toString() ?? '',
                onChanged: (value) {
                  setState(() {
                    if (key == 'quantity') {
                      editingItem![key] = int.tryParse(value) ?? 0;
                    } else if (key == 'price') {
                      editingItem![key] = double.tryParse(value) ?? 0.0;
                    } else if (key == 'category') {
                      editingItem![key] = ItemCategoryExtension.fromString(value);
                    } else {
                      editingItem![key] = value;
                    }
                  });
                },
              )
            : Text(
                item[key]?.toString() ?? '',
                textAlign: TextAlign.center,
              ),
      ),
      showEditIcon: editingItem == null || editingItem!['id'] != item['id'],
      onTap: () {
        if (editingItem == null) {
          _editItem(item);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = inventoryItems
        .where((item) => item['name'].toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.sizeOf(context).width * 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _addNewItem,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Text(
                        "Add New Item",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.68,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Looking for anything ...',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              //searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          // Trigger search here if needed
                        },
                        child: Container(
                          width: 90,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(249, 139, 245, 144),
                          ),
                          child: const Center(
                            child: Text(
                              'search',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green),
            columns: const [
              DataColumn(
                label: Center(
                  child: Text(
                    'Name',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Category',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Price',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Quantity',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Expiry Date',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Supplier',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Barcode',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    'Actions',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: filteredItems.map((item) {
              final isEditing = editingItem != null && editingItem!['id'] == item['id'];
              return DataRow(
                cells: [
                  _buildEditableCell(item, 'name'),
                  _buildEditableCell(item, 'category'),
                  _buildEditableCell(item, 'price'),
                  _buildEditableCell(item, 'quantity'),
                  _buildEditableCell(item, 'expiryDate'),
                  _buildEditableCell(item, 'supplier'),
                  _buildEditableCell(item, 'barcode'),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(isEditing ? Icons.save : Icons.edit),
                          onPressed: () {
                            if (isEditing) {
                              _saveItem();
                            } else {
                              _editItem(item);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteItem(item),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => widget.onAddToCart(item['id']),
                          icon: Icon(Icons.add_shopping_cart),
                          label: Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
