import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.arrow_left,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
                  bottomRight: Radius.circular(0)),
              color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.26,
                      height: MediaQuery.sizeOf(context).height * 0.15,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromARGB(253, 255, 241, 150),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 40,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'GH₵.....',
                            style: GoogleFonts.archivo(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Current Account Balance',
                            style: GoogleFonts.archivo(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 2,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const SingleChildScrollView(
                      //child: SalesBarChart(),
                      ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: MediaQuery.sizeOf(context).width * 1,
              child: TransactionTable(),
            )
            
          ],
        ),
      ),
    );
  }
}
