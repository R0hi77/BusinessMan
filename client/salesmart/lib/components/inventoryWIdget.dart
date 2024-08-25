import 'package:flutter/material.dart';
import 'package:salesmart/services/inventoryService.dart';

class InventoryTable extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onItemsSelected;

  const InventoryTable({Key? key, required this.onItemsSelected})
      : super(key: key);

  @override
  _InventoryTableState createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  final InventoryService _inventoryService = InventoryService();
  List<Map<String, dynamic>> inventoryItems = [];
  List<Map<String, dynamic>> selectedItems = [];
  Map<String, dynamic>? editingItem;

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  Future<void> _loadInventoryItems() async {
    final items = await _inventoryService.getInventoryList('');
    setState(() {
      inventoryItems = items ?? [];
    });
  }

  void toggleItemSelection(Map<String, dynamic> item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
      widget.onItemsSelected(selectedItems);
    });
  }

  void _addNewItem() {
    setState(() {
      final newItem = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': '',
        'category': '',
        'price': '',
        'quantity': '',
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
    });
  }

  void _saveItem() async {
    if (editingItem != null) {
      final index = inventoryItems.indexWhere((item) => item['id'] == editingItem!['id']);
      if (index != -1) {
        setState(() {
          inventoryItems[index] = editingItem!;
        });
        // Save to backend
        await _inventoryService.updateInventoryItem(editingItem!,'');
      } else {
        setState(() {
          inventoryItems.add(editingItem!);
        });
        // Save to backend
        await _inventoryService.addInventoryItem(editingItem!,'');
      }
      setState(() {
        editingItem = null;
      });
    }
  }

  void _deleteItem(Map<String, dynamic> item) async {
    setState(() {
      inventoryItems.removeWhere((element) => element['id'] == item['id']);
      selectedItems.remove(item);
    });
    // Delete from backend
    await _inventoryService.deleteInventoryItem(item['id'],'');
    widget.onItemsSelected(selectedItems);
  }

 DataCell _buildEditableCell(String key, String label) {
    return DataCell(
      editingItem != null && editingItem!['id'] == key
          ? TextFormField(
              initialValue: editingItem![key]?.toString() ?? '',
              onChanged: (value) {
                editingItem![key] = value;
              },
            )
          : Text(label),
      showEditIcon: true,
      onTap: () {
        if (editingItem == null) {
          _editItem(inventoryItems.firstWhere((item) => item['id'] == key));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
               child: Text("Add New Item",
               style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
               ),),
             ), 
            ),
          ),

          // ElevatedButton(
          //   onPressed: _addNewItem,
          //   child: Text('Add New Item'),
          // ),
          
          DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Expiry Date')),
              DataColumn(label: Text('Supplier')),
              DataColumn(label: Text('Barcode')),
              DataColumn(label: Text('Actions')),
            ],
            rows: inventoryItems.map((item) {
              final isSelected = selectedItems.contains(item);
              final isEditing = editingItem != null && editingItem!['id'] == item['id'];
              return DataRow(
                cells: [
                  _buildEditableCell('name', item['name'] ?? ''),
                  _buildEditableCell('category', item['category'] ?? ''),
                  _buildEditableCell('price', 'GH₵${item['price'] ?? ''}'),
                  _buildEditableCell('quantity', item['quantity']?.toString() ?? ''),
                  _buildEditableCell('expiryDate', item['expiryDate'] ?? ''),
                  _buildEditableCell('supplier', item['supplier'] ?? ''),
                  _buildEditableCell('barcode', item['barcode'] ?? ''),
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
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            toggleItemSelection(item);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                selected: isSelected,
                onSelectChanged: (bool? value) {
                  toggleItemSelection(item);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}