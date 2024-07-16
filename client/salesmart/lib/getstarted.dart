import 'package:flutter/material.dart';
import 'package:salesmart/register.dart';
import 'package:salesmart/welcomeback.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Image(
                  image: const AssetImage("assets/images/bigshop.jpg"),
                  height: MediaQuery.sizeOf(context).height * 0.75,
                  width: MediaQuery.sizeOf(context).width * 0.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(95, 30, 95, 30),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.4,
                height: MediaQuery.sizeOf(context).height * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ghana's",
                            style: TextStyle(
                                fontSize: 60,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "No.1",
                            style: TextStyle(
                                fontSize: 50,
                                color: Color.fromARGB(255, 128, 0, 128),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const Text(
                      "Inventory",
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Management",
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
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
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.008,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Welcome()));
                          },
                          child: const Text("Log in",
                              style: TextStyle(
                                color: Color.fromARGB(255, 128, 0, 128),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
