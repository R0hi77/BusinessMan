import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salesmart/components/circle.dart';
import 'package:salesmart/screens/verify.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String? shop;
  PhoneNumber? number;
  String? email;
  String? businessAddress;
  String? password;
  String phoneString = '';


  Future<int> postData(PhoneNumber? number) async {
    var url = Uri.parse('http://localhost:5000/api/auth/register');
    var headers = {'Content-Type': 'application/json; charset=utf-8'};

   
    // Perform a null check before accessing properties
    if (number != null) {
      phoneString = number.number;
    }

    var payload = {
      'shop_name': shop,
      'email': email,
      'password': password,
      'number': phoneString,
      'business_address': businessAddress
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      return 200;
    } else {
      return 400;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  bottomRight: Radius.circular(0)),
              color: Colors.green),
        ),
      ),
      body: Container(
        // color: Color.fromARGB(255, 183, 228, 183),
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(80.0, 0, 60, 0),
            child: Container(
                height: MediaQuery.sizeOf(context).height * 0.8,
                width: MediaQuery.sizeOf(context).width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register your shop ",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Verification OTP will be sent to shop mobile money number",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 128, 0, 128),
                              fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 10,),
                        Text(
                          "Ensure it is a valid mobile money number",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 128, 0, 128),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                    // Form
                    Form(
                      key: _formGlobalKey,
                      child: Column(
                        children: [
                          // Phone Field
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                hintText: "mobile money number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "Enter a valid mobile number";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  number = value;
                                });
                              },
                            ),
                          ),
                          // Shop Name Field
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your shop's name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "You must enter a shop name";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  shop = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.03,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "You must enter a valid password";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.03,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your shop's Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "You must enter a shop email";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.03,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Business Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field can not be empty";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  businessAddress = value;
                                });
                              },
                            ),
                          ),

                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.06,
                          ),
                          // Submit Button
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.19,
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.green,
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (_formGlobalKey.currentState?.validate() ==
                                    true) {
                                  _formGlobalKey.currentState?.save();
                                  postData(number);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VerificationPage(
                                        phoneNumber: phoneString
                                        )));
                                }
                                
                              },
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Send OTP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),

          // space
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.05,
          ),

          Center(
            child: Stack(alignment: Alignment.center, children: [
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 700,
                            width: 700,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Image(
                                image: AssetImage(
                                    '/home/petersburg/Desktop/BusinessManager/client/salesmart/assets/images/imagenice.png')),
                          )
                        ],
                      ),
                    ]),
              ),
              CircleWidget(
                circle: Circle(radius: 300.0, color: Colors.green),
              ),
              //CircleWidget( circle: Circle(radius: 100.0, color: Colors.black),),
            ]),
          ),
        ]),
      ),
    );
  }
}
