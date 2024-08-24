import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:salesmart/screens/create_account.dart';
import 'dart:convert';

class LoginShop extends StatefulWidget {
  const LoginShop({Key? key}) : super(key: key);

  @override
  _LoginShopState createState() => _LoginShopState();
}

class _LoginShopState extends State<LoginShop> {
  final _formGlobalKey = GlobalKey<FormState>();

  String password = '';
  String phone_number = '';

  Future<Map<String, dynamic>> postData() async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/api/auth/loginasshop'),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
    body: jsonEncode({
      'number': phone_number,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return {
      'status': 200,
      'access_token': responseData['access_token'] ?? '',
    };
  } else {
    return {'status': response.statusCode, 'access_token': ''};
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
      body: Stack(
        children: [
          Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(children: [
                  const Icon(
                    Icons.storefront_outlined,
                    size: 120,
                    color: Color.fromARGB(255, 35, 35, 36),
                  ),
                  const Text(
                    "Log Into Shop Account",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formGlobalKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              hintText: "shop mobile money number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (phone) {
                              setState(() {
                                phone_number = phone.completeNumber;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password field can not be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.065,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            onPressed: () {
                    if (_formGlobalKey.currentState?.validate() == true) {
                            postData().then((result) {
                              if (result['status'] == 200 && result['access_token'].isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(
                                    token: result['access_token'],
                                  ),
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login failed. Please check your credentials and try again.'),
                                  ),
                                );
                              }
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('An error occurred: $error')),
                              );
                            });
                          }
                        },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
          )
        ],
      ),
    );
  }
}
