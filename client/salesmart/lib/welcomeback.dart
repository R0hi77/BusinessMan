import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return  
      Scaffold(
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
        body:   Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Text("Welcome Back!",
              style: TextStyle(fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(225, 128, 0, 128)),
              ),
              
             const  SizedBox(
                height: 40,
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
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login as manager",
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

              // sized box
               const  SizedBox(
                height: 40,
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
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Login as Attendant",
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

              //sized box

             const  SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
    );
  }
}
