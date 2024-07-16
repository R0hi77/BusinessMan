//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formGlobalKey = GlobalKey<FormState>();
  String _shop = '0';
  PhoneNumber _number = PhoneNumber(
      countryISOCode: '+1', number: '1234567890', countryCode: '+233');

  void postData() async {
    var response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/register'),
        body: {"shop_name": _shop, 
        "number": _number.number});

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              "SaleSmart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(225, 128, 0, 128),
                Color.fromARGB(224, 0, 0, 0),
              ])),
        ),
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.75,
              width: MediaQuery.sizeOf(context).width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 145, 140, 145),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(140, 30, 95, 30),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.75,
              width: MediaQuery.sizeOf(context).width * 0.36,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(223, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Your shop ",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.09,
                      ),
                      const Text(
                        "on the go!",
                        style: TextStyle(
                            fontSize: 40,
                            color: Color.fromARGB(255, 128, 0, 128),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  // sized box to create space
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  ),

                  //text form field
                  Form(
                    key: _formGlobalKey,
                    child: Column(children: [
                      //phone
                      IntlPhoneField(
                        decoration: const InputDecoration(
                            //prefixIcon: Icon(Icons.phone),
                            labelText: "Mobile money number",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                        validator: (value) {
                          if (value == null) {
                            return "enter a valid mobile number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          value = _number;
                        },
                      ),
                      //password
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Shop Name",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "You must enter a shop name ";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          value = _shop;
                        },
                      ),

                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.09),

                      //submit button
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.23,
                        height: MediaQuery.sizeOf(context).height * 0.09,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(225, 128, 0, 128),
                              Color.fromARGB(224, 0, 0, 0)
                            ])),
                        child: TextButton(
                          onPressed: () {
                            if (_formGlobalKey.currentState?.validate() ==
                                true) {
                              _formGlobalKey.currentState?.save();
                              postData();
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Register your shop",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward_sharp,
                                color: Colors.white,
                                weight: 8,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
