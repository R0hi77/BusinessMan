import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:salesmart/services/shopAccountDetails.dart'; // This should contain fetchAccountDetails function
import 'package:salesmart/services/transactionData.dart'; // This should contain postTransactionData function

enum ItemCategory { others, electronics, groceries, clothing }

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final String token;

  const CheckoutPage({Key? key, required this.cartItems, required this.total, required this.token})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String? _paymentMethod;
  String _customerName = '';
  String _customerEmail = '';
  String _customerPhoneNumber = '';

  late String _currentDate;
  late String _currentTime;
  late String _transactionId;

  late String shop_name ;
  late String business_address = 'shop address goes here';
  late String shop_number = 'shop number goes here';
  late String shop_email = 'shop email goes here';

  double _amountPaid = 0;

  // Reference to the cart items passed from CartPage
  List<Map<String, dynamic>> get _products => widget.cartItems;

  double get _subtotal => _products.fold(
      0, (sum, product) => sum + (product['price'] * product['quantity']));
  double get _tax => _subtotal * 0.15; // Optional: If tax is to be considered
  double get _total => widget.total; // Use the total passed from CartPage

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _generateTransactionId();
    getAccountDetails(); // Call to fetch shop details
  }

  void _updateDateTime() {
    DateTime now = DateTime.now();
    _currentDate = DateFormat('yyyy-MM-dd').format(now);
    _currentTime = DateFormat('HH:mm').format(now);
  }

  void _generateTransactionId() {
    var uuid = const Uuid();
    _transactionId = uuid.v4().substring(0, 8).toUpperCase();
  }

  Future <void> getAccountDetails() async {
    String jwtToken =
        'your_jwt_token_here'; // Replace with the actual JWT token
    try {
      Map<String, dynamic> accountDetails = await fetchAccountDetails(jwtToken);
      shop_name = accountDetails['shop'];
      business_address = accountDetails['address'];
      shop_number = accountDetails['number'];
      shop_email = accountDetails['email'];
    } catch (e) {
      print('Error fetching account details: $e');
    }
  }

  Future<void> _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      String jwtToken =
          'your_jwt_token_here'; // Replace with the actual JWT token

      Map<String, dynamic> transactionData = {
        'number': _customerPhoneNumber,
        'cash_in': _total,
        'payment_type': _paymentMethod,
        'balance': _amountPaid - _total,
        'items': _products
            .map((product) => {
                  'product_name': product['name'],
                  'quantity': product['quantity'],
                  'price_per_item': product['price'],
                })
            .toList(),
      };

      int statusCode = await postTransactionData(transactionData, jwtToken);
      if (statusCode == 200) {
        // Transaction posted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction submitted successfully')),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit transaction')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text("SaleSmart",
                style: GoogleFonts.archivoBlack(
                    textStyle:
                        const TextStyle(fontSize: 30, color: Colors.black)))
          ],
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
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
        padding: const EdgeInsets.all(50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Information
              const Text(
                'Your Shop Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('${business_address}, Ghana'),
              Text('Phone: ${shop_number}'),
              Text('Email: ${shop_email}'),
              SizedBox(height: 20),

              // Invoice Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice #: INV-$_transactionId'),
                  Text('Date: $_currentDate'),
                ],
              ),
              SizedBox(height: 20),

              // Customer Information
              const Text('Bill To:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Customer Name', border: OutlineInputBorder()),
                onChanged: (value) => _customerName = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Customer Email', border: OutlineInputBorder()),
                onChanged: (value) => _customerEmail = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Customer Phone Number',
                    border: OutlineInputBorder()),
                onChanged: (value) => _customerPhoneNumber = value,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 50),

              // Product Table
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2), // Product name
                  1: FlexColumnWidth(3), // Description
                  2: FlexColumnWidth(1), // Quantity
                  3: FlexColumnWidth(1.5), // Price
                  4: FlexColumnWidth(2) // Amount
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: const [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Product',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Description',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Qty',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                  ..._products
                      .map((product) => TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(product['name']),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(product['description']),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(product['quantity'].toString()),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                    'GH₵${product['price'].toStringAsFixed(2)}'),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                    'GH₵${(product['price'] * product['quantity']).toStringAsFixed(2)}'),
                              )),
                            ],
                          ))
                      .toList(),
                ],
              ),
              const SizedBox(height: 20),

              // Totals
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total: GH₵${_total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                value: _paymentMethod,
                items: ['Mobile Money', 'Cash'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _paymentMethod = newValue;
                  });
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Additional fields based on payment method
              if (_paymentMethod == 'Mobile Money') ...[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _customerPhoneNumber = value,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
              if (_paymentMethod == 'Cash') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _amountPaid = double.tryParse(value) ?? 0;
                          });
                        },
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Balance: GH₵${(_amountPaid - _total).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

              // Terms and Conditions
              const Text('Terms and Conditions:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                  '1. Products purchased cannot be returned after 24 hours'),
              const Text('2. Please include the invoice number on your check'),
              const SizedBox(height: 20),

              // Thank You Note
              const Center(
                child: Text('Thank you for your business!',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  child: const Text('Generate Invoice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
