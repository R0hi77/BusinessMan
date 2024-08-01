import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/screens/login_as_manager.dart';
import 'package:salesmart/components/dropdown.dart';
import 'package:salesmart/screens/login_as_attendant.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
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
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Form(
              child: Column(
                children: [
                  // Shop Name Field
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
                      onSaved: (value) {},
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.04,
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
                          return "You must a password";
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.04,
                  ),

                  // drop down textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownListTextField(
                      items: [
                        'Perishables',
                        'Pharmacy',
                        'SuperMarket',
                        'Warehouse store',
                        'specialty store'
                      ],
                      hint: 'Select your shop type',
                      onChanged: (String? newValue) {
                        // Handle the value change
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select your shop type';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Submit Button
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.03,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.2,
                    height: MediaQuery.sizeOf(context).height * 0.065,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.green,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // if (_formGlobalKey.currentState?.validate() == true) {
                        //   _formGlobalKey.currentState?.save();
                        //   postData();
                        // }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPageAttendant()));
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
        //
        Padding(
          padding: const EdgeInsets.fromLTRB(200, 50, 10, 0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: MediaQuery.sizeOf(context).height * 0.75,
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
                      Text("Complete the form to create an manager account ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.archivo(
                              textStyle: const TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      const Image(
                        image: AssetImage(
                            '/home/petersburg/Desktop/BusinessManager/client/salesmart/lib/components/managerregister.png'),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [
                            Icon(Icons.inventory_2_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Manage Inventory',
                              style: TextStyle(fontSize: 15),
                            ),
                          ]),
                          Row(children: [
                            Icon(Icons.analytics_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Data Analytics',
                              style: TextStyle(fontSize: 15),
                            ),
                          ]),
                          Row(children: [
                            Icon(Icons.inventory_2_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Attendant activity Tracking ',
                              style: TextStyle(fontSize: 15),
                            ),
                          ]),
                          Row(children: [
                            Icon(Icons.payment),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Integreted payments',
                              style: TextStyle(fontSize: 20),
                            ),
                          ])
                        ],
                      )
                    ])),
          ),
        ),
      ]),
    );
  }

  Widget _buildTextField({required String hint, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // Handle create account action
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.green, // Main color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Create account',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
