import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(250, 160, 252, 180),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Streamline Your Stock Control with Salesmart",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),

              Lottie.asset(
                'assets/animations/inventory.json',
                repeat: true,
                width: 500,
                height: 500,
              ),
              // const Text("Streamline Your Stock Control",
              // style: TextStyle(
              //   fontSize: 50,
              //   fontWeight: FontWeight.bold
              // ),),
              const Text(
                "Real-Time inventory tracking ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Automated reorder alerts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const Text(
                " Detailed product categorization",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
