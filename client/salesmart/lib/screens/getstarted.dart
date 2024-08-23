import 'package:flutter/material.dart';
import 'package:salesmart/screens/register.dart';


class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green,
        //   toolbarHeight: MediaQuery.sizeOf(context).height*0.5,
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height:MediaQuery.sizeOf(context).height*0.5,
                width: MediaQuery.sizeOf(context).width*0.5,
                decoration: const BoxDecoration(
                  color:  Colors.white,
                  image:  DecorationImage(image: AssetImage('/home/petersburg/Desktop/BusinessManager/client/salesmart/assets/images/isometric-financial-robo-assistant-helping-a-man.png')
                  ,scale: 0.3),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                    bottom: Radius.circular(1)
                    //left:Radius.circular(12)
                    )
                ),
                //child: const Image(image: AssetImage('/home/petersburg/Desktop/BusinessManager/client/salesmart/assets/images/isometric-financial-analytics-on-stock-market.png')),
              ),
               Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Manage your retail business in one place",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  const Text('Seamless payments handling, business insights inventory,',
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 107, 107),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                  ),

                 const  Text('management and tracking all from a single app',
                  style: TextStyle(
                    color: Color.fromARGB(255, 107, 107, 107),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.1,
                  ),

                  InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                    } ,
                    child: Container(
                      height: MediaQuery.sizeOf(context).height*0.075,
                      width: MediaQuery.sizeOf(context).width*0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green
                      ),
                      
                        child: const  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[  Text('Get started',
                          style: TextStyle(color:Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          ),
                          ),
                          Icon(Icons.arrow_forward,
                          size: 27,
                          weight: 70,),
                          
                    ]),
                      
                    ),
                    
                  )
                ],
              )
          ]
        
          ),
        ),
        )
    );
  }
}