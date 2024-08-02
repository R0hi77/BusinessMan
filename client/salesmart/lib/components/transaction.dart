import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  final String id;  // Changed from int to String for UUID
  final String transactionDate;
  final double cash;
  final String paymentMethod;
  final double balance;
  final String attendant;
  final String timestamp;
  final String product;
  final int quantity;
  final double price;

  Transaction({
    required this.id,
    required this.transactionDate,
    required this.cash,
    required this.paymentMethod,
    required this.balance,
    required this.attendant,
    required this.timestamp,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],  // Now expecting a String UUID
      transactionDate: json['transaction_date'],
      cash: json['cash'].toDouble(),
      paymentMethod: json['payment_method'],
      balance: json['balance'].toDouble(),
      attendant: json['attendant'],
      timestamp: json['timestamp'],
      product: json['product'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}

class TransactionTable extends StatefulWidget {
  @override
  _TransactionTableState createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('YOUR_API_ENDPOINT_URL'),
        headers: {
          'Authorization': 'Bearer YOUR_JWT_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _transactions = jsonData.map((json) => Transaction.fromJson(json)).toList();
        });
      } else {
        print('Failed to load transactions: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load transactions. Please try again.')),
        );
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please check your connection and try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     style: const ButtonStyle(
        //       backgroundColor: MaterialStatePropertyAll(Colors.green)
        //     ),
        //     onPressed: _isLoading ? null : () {
        //       _fetchTransactions();
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Refreshing data...')),
        //       );
        //     },
        //     child: Text(_isLoading ? 'Updating...' : 'Refresh Data',
        //     style: const TextStyle(color: Colors.black),),
        //   ),
        // ),
        Expanded(
          child: _isLoading
              ? const  Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      //
                      headingRowColor: MaterialStateProperty.all(const Color.fromARGB(249, 159, 245, 205)),
                      columns: const [
                       DataColumn(label: Text('ID',
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ),)),

                        DataColumn(label: Text('Date',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),

                        DataColumn(label: Text('Cash',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),

                        DataColumn(label: Text('Payment Method',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),

                        DataColumn(label: Text('Balance',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),

                        DataColumn(label: Text('Attendant Name',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),


                        DataColumn(label: Text('Product Name',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),
                        DataColumn(label: Text('Quantity',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),

                        DataColumn(label: Text('Price',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                       ))),
                      ],
                      rows: _transactions.map((transaction) {
                        return DataRow(cells: [
                          DataCell(Text(transaction.id)),  // Now displaying UUID as a string
                          DataCell(Text(transaction.transactionDate)),
                          DataCell(Text('\$${transaction.cash.toStringAsFixed(2)}')),
                          DataCell(Text(transaction.paymentMethod)),
                          DataCell(Text('\$${transaction.balance.toStringAsFixed(2)}')),
                          DataCell(Text(transaction.attendant)),
                          DataCell(Text(transaction.product)),
                          DataCell(Text(transaction.quantity.toString())),
                          DataCell(Text('\$${transaction.price.toStringAsFixed(2)}')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}