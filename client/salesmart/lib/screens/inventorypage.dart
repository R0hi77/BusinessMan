import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/inventoryWidget.dart';
import 'package:salesmart/screens/addtocart.dart';
import 'package:salesmart/services/inventoryService.dart';

class InventoryPage extends StatefulWidget {
  final String token;

  InventoryPage({Key? key, required this.token}) : super(key: key);

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  // Define the GlobalKey for InventoryTable
  final GlobalKey<InventoryTableState> _inventoryTableKey = GlobalKey<InventoryTableState>();

  late final InventoryService inventoryService;
  Map<String, int> cartItems = {}; // Map of item ID to quantity
  String searchQuery = '';
  late String token;
  int totalCartItems = 0;

  @override
  void initState() {
    super.initState();
    inventoryService = InventoryService();
    token = widget.token;
  }

  void addToCart(String itemId) {
    setState(() {
      cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
      totalCartItems = cartItems.values.fold(0, (sum, quantity) => sum + quantity);
    });
  }

  void proceedToCheckout() async {
    List<Future<Map<String, dynamic>>> futures = cartItems.entries.map((entry) async {
      final item = await inventoryService.getInventoryItemById(entry.key, token);
      if (item != null) {
        return {
          ...item as Map<String, dynamic>,
          'quantity': entry.value,
        };
      } else {
        return <String, dynamic>{}; // Return an empty map if item is null
      }
    }).toList();

    List<Map<String, dynamic>> selectedItems = await Future.wait(futures);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(initialCartItems: selectedItems, token: token),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "SaleSmart",
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 45,
                  onPressed: totalCartItems > 0 ? proceedToCheckout : null,
                ),
                if (totalCartItems > 0)
                  Positioned(
                    right: 4,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$totalCartItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    InventoryTable(
                      key: _inventoryTableKey, // Pass the key here
                      onAddToCart: addToCart,
                      searchQuery: searchQuery,
                      token: token,
                    ),
                    SizedBox(height: 20), // Add some space between the table and the button
                    ElevatedButton(
                      onPressed: totalCartItems > 0 ? proceedToCheckout : null,
                      child: Text('Proceed to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20), // Add space between buttons
                    ElevatedButton(
                      onPressed: () async {
                        // Call saveAllItems from InventoryWidget
                        await _inventoryTableKey.currentState?.saveAllItems(token); // Correctly call saveAllItems
                        // Optionally, show a snackbar or dialog indicating success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('All items saved successfully!')),
                        );
                      },
                      child: Text('Save All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
