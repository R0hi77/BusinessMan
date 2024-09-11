import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/dropdown.dart';
import 'package:salesmart/screens/login_as_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class CreateAccountScreen extends StatefulWidget {
  final String token;
  const CreateAccountScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String? shopType;
  String? shopId;

  @override
  void initState() {
    super.initState();
    extractShopId();
  }

  void extractShopId() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    shopId = decodedToken['shop_id'];
  }

  Future<int> postData() async {
    var url = Uri.parse('http://localhost:5000/api/auth/createmanager');
    var body = {
      'username': username,
      'password': password,
      'shopType': shopType,
      'shopId': shopId,
    };

    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${widget.token}',
    };
    var response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    return response.statusCode;
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
                        const TextStyle(fontSize: 30, color: Colors.black))),
          ],
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
              color: Colors.green),
        ),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(90.0, 200, 0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Set up manager account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter a username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must enter a user name";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                          return "You must enter a password";
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownListTextField(
                      items: const [
                        'Perishables',
                        'Pharmacy',
                        'SuperMarket',
                        'Warehouse store',
                        'Specialty store'
                      ],
                      hint: 'Select your shop type',
                      onChanged: (String? newValue) {
                        setState(() {
                          shopType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select your shop type';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.065,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          _formKey.currentState?.save();
                          print(shopId);
                          try {
                            int statusCode = await postData();
                            if (statusCode == 200) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>  LoginPageManager(token: widget.token,),
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Failed to create account. Please try again.')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'An error occurred. Please try again later.')),
                            );
                          }
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Submit",
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "The simplest way to manage your business and workforce",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.archivo(
                              textStyle: const TextStyle(
                                  fontSize: 50, color: Colors.black))),
                      Text("Complete the form to create a manager account ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.archivo(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      const Image(
                        image: AssetImage(
                            '/home/petersburg/Desktop/BusinessManager/client/salesmart/lib/components/managerregister.png'),
                      ),
                      const SizedBox(height: 100),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [
                            Icon(Icons.inventory_2_rounded),
                            SizedBox(width: 8),
                            Text('Manage Inventory',
                                style: TextStyle(fontSize: 15)),
                          ]),
                          Row(children: [
                            Icon(Icons.analytics_outlined),
                            SizedBox(width: 8),
                            Text('Data Analytics',
                                style: TextStyle(fontSize: 15)),
                          ]),
                          Row(children: [
                            Icon(Icons.inventory_2_rounded),
                            SizedBox(width: 8),
                            Text('Attendant activity Tracking ',
                                style: TextStyle(fontSize: 15)),
                          ]),
                          Row(children: [
                            Icon(Icons.payment),
                            SizedBox(width: 8),
                            Text('Integrated payments',
                                style: TextStyle(fontSize: 20)),
                          ])
                        ],
                      )
                    ])),
          ),
        ),
      ]),
    );
  }
}
