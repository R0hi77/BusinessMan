import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/screens/dashboard2.dart';

class LoginPageAttendant extends StatelessWidget {
  const LoginPageAttendant({super.key});

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
      body: Stack(
        children: [
          Center(
            child: Container(
                height: MediaQuery.sizeOf(context).height * 0.65,
                width: MediaQuery.sizeOf(context).width * 0.25,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(children: [
                  const Icon(
                    Icons.supervised_user_circle,
                    size: 120,
                    color: Color.fromARGB(255, 35, 35, 36),
                  ),
                  const Text(
                    "Attendant",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Form(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        // username

                       TextFormField(
                            decoration: InputDecoration(
                              hintText: "Username",
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


                        const SizedBox(
                          height: 30,
                        ),

                        // password
                        TextFormField(
                          obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
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


                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                        ),
                        // Submit Button
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          height: MediaQuery.sizeOf(context).height * 0.065,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DashboardPage2()));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
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

Widget _buildTextField({required String hint, bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45),
      filled: true,
      fillColor: Colors.black12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
    ),
  );
}
