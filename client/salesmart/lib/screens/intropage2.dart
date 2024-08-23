import 'package:flutter/material.dart';


class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        color:const Color.fromARGB(253, 255, 241, 150),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Gain Valuable sales Insights with Salesmart",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),),
              Image(image: AssetImage("/home/petersburg/Desktop/BusinessManager/client/salesmart/assets/images/isometric-statistical-data-for-financial-analysis.png")),
              Text("Daily, weekly, and monthly report generation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),),
              Text("Product performance analysis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),),

            ],
          ),
        ),

      ),
    );
  }
}