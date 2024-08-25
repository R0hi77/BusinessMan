import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/screens/checkout.dart';

enum ItemCategory {
  food,
  electronics,
  clothing,
  books,
  toys,
  other,
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> initialCartItems;

  const CartPage({Key? key, required this.initialCartItems}) : super(key: key);

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

  final Map<ItemCategory, Color> categoryColors = {
    ItemCategory.food: Colors.green[100]!,
    ItemCategory.electronics: Colors.blue[100]!,
    ItemCategory.clothing: Colors.purple[100]!,
    ItemCategory.books: Colors.orange[100]!,
    ItemCategory.toys: Colors.red[100]!,
    ItemCategory.other: Colors.grey[100]!,
  };

  final Map<ItemCategory, IconData> categoryIcons = {
    ItemCategory.food: Icons.fastfood,
    ItemCategory.electronics: Icons.electrical_services,
    ItemCategory.clothing: Icons.checkroom,
    ItemCategory.books: Icons.book,
    ItemCategory.toys: Icons.toys,
    ItemCategory.other: Icons.category,
  };

  Color getItemColor(ItemCategory category) {
    return categoryColors[category]!;
  }

  IconData getItemIcon(ItemCategory category) {
    return categoryIcons[category]!;
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
        title: Text(
          "Cart",
          style: GoogleFonts.archivoBlack(
            textStyle: const TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
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
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty!',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                // Total and Checkout Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: const BoxDecoration(
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
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'GH₵${total.toStringAsFixed(2)}',
                              style: GoogleFonts.roboto(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CheckoutPage(),
                            ));
                          },
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Cart Items Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(60),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [getItemColor(item['category']).withOpacity(0.5), getItemColor(item['category'])],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  //getItemIcon(item['category']),
                                  Icons.abc,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['name'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'GH₵${item['price']}',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove, size: 20, color: Colors.grey[600]),
                                          onPressed: () {
                                            setState(() {
                                              if (item['quantity'] > 1) {
                                                item['quantity']--;
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Remove Item'),
                                                    content: const Text('Are you sure you want to remove this item?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            cartItems.removeAt(index);
                                                          });
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Remove'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '${item['quantity']}',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add, size: 20, color: Colors.grey[600]),
                                          onPressed: () {
                                            setState(() {
                                              item['quantity']++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Remove Item'),
                                            content: const Text('Are you sure you want to remove this item?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    cartItems.removeAt(index);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
