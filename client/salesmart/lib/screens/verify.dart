import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/successdialog.dart';
import 'package:salesmart/screens/login_shop.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;
  const VerificationPage({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  int _counter = 300; // 5 minutes in seconds
  late Timer _timer;
  String _enteredOTP = '';
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _isResendEnabled = true;
          _timer.cancel();
        }
      });
    });
  }

Future<void> verifyOTP() async {
  try {
    // Prepare the request body
    final body = {
      'otp': _enteredOTP,
      'number': widget.phoneNumber?.toString() ?? '',
    };

    // Log the request body for debugging
    print('Request body: $body');

    // Send the POST request
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/confirm'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // Log the response for debugging
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the response
      final jsonResponse = json.decode(response.body);
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessDialog(
            description: jsonResponse['message'] ?? 'OTP verified successfully',
            onOkPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  LoginShop()),
              );
            },
          );
        },
      );
    } else if (response.statusCode == 400) {
      // Handle bad request
      final jsonResponse = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonResponse['error'] ?? 'Invalid OTP or phone number')),
      );
    } else {
      // Handle other status codes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error. Status code: ${response.statusCode}')),
      );
    }
  } catch (e) {
    // Handle network errors or other exceptions
    print('Error in verifyOTP: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: ${e.toString()}')),
    );
  }
}


  void resendOTP() async {
  // Make the API call to resend the OTP
  final response = await http.post(
    Uri.parse('http://localhost:5000/api/auth/resend'), // Replace with your API endpoint
    headers: <String,String>{
      'Content-Type': 'application/json',
    },
    body: {"number": widget.phoneNumber}, // Replace with your request body
  );

  // Check if the API call was successful
  if (response.statusCode == 200) {
    // Process the response if needed

    // Update the UI
    setState(() {
      _counter = 300;
      _isResendEnabled = false;
    });

    startTimer();
  } else {
    // Handle errors here
    print('Failed to resend OTP: ${response.body}');
  }
}


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "SaleSmart",
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              const Text(
                "Verification",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text(
                  "Enter the OTP sent to your shop mobile money number",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Verify number: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "+233${widget.phoneNumber}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.green),
                  ),
                ),
                onCompleted: (pin) {
                  setState(() {
                    _enteredOTP = pin;
                  });
                  verifyOTP();
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Resend OTP in ${_counter ~/ 60}:${(_counter % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _isResendEnabled ? resendOTP : null,
                child: Container(
                  width: 300,
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}