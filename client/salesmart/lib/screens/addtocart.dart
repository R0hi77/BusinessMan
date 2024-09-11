import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/screens/checkout.dart';
import 'package:salesmart/screens/inventorypage.dart'; // Import your inventory page

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialCartItems;
  final String token;

  const CartPage({Key? key, required this.initialCartItems, required this.token}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.initialCartItems;
  }

  double get total => cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary:'),
              SizedBox(height: 10),
              ...cartItems.map((item) => Text('${item['name']} x ${item['quantity']}')),
              SizedBox(height: 10),
              Text('Total: GH₵${total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CheckoutPage(cartItems: cartItems, total: total, token:''),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "Cart",
          style: GoogleFonts.archivoBlack(
            textStyle: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InventoryPage(token: widget.token),
              ));
            },
            child: Text('Back to Inventory', style: TextStyle(color: Colors.black)),
          ),
        ],
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            color: Colors.green,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty!',
                style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(253, 255, 241, 150),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total: (${cartItems.length} items)',
                              style: GoogleFonts.roboto(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'GH₵${total.toStringAsFixed(2)}',
                              style: GoogleFonts.roboto(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _showConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text('Checkout', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Category: ${item['category']}'),
                              Text('Price: GH₵${item['price'].toStringAsFixed(2)}'),
                              Text('Quantity: ${item['quantity']}'),
                              Text('Subtotal: GH₵${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                              Text('Expiry Date: ${item['expiryDate']}'),
                              Text('Supplier: ${item['supplier']}'),
                              Text('Barcode: ${item['barcode']}'),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (item['quantity'] > 1) {
                                              item['quantity']--;
                                            } else {
                                              cartItems.removeAt(index);
                                            }
                                          });
                                        },
                                      ),
                                      Text('${item['quantity']}'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            // Here you would typically check against available inventory
                                            item['quantity']++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (cartItems.isNotEmpty) {
            _showConfirmationDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your cart is empty. Add items before checking out.')),
            );
          }
        },
        label: Text('Checkout'),
        icon: Icon(Icons.shopping_cart_checkout),
        backgroundColor: Colors.green,
      ),
    );
  }
}