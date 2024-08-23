import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
      color:  const Color.fromARGB(253, 255, 241, 150),
      child:  Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         const  Text("Offer your customers convenient payment options",
         textAlign: TextAlign.justify,
          style:TextStyle(fontSize: 50,
          fontWeight: FontWeight.bold)
          ),
          const  Text("while keeping your accounts in perfect order",
         textAlign: TextAlign.justify,
          style:TextStyle(fontSize: 50,
          fontWeight: FontWeight.bold)
          ),

          Lottie.asset(
                '/home/petersburg/Desktop/BusinessManager/client/salesmart/assets/animations/pay.json',
                repeat: true,
                width: 500,
                height: 500,
              ),

          const Text(" Accept mobile money payment via USSD prompts",
          style: TextStyle(fontSize: 22,
          fontWeight: FontWeight.bold),),
          const Text("Charges are automatically added to customers cost",
          style: TextStyle(fontSize: 22,
          fontWeight: FontWeight.bold),),
          
          // const Text("Offer your customers convenient payment options while keeping your accounts in perfect order",
          // style: TextStyle(fontSize: 22,
          // fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      ),
    );
  }
}