import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/inventory.dart';
import 'package:salesmart/components/saveInventory.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({super.key});
  final InventoryService inventoryService = InventoryService();
  

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final InventoryService inventoryService;
  

  @override
  void initState() {
    super.initState();
    inventoryService = InventoryService();
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.68,
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Looking for anything ...',
                        border: OutlineInputBorder(
                            //borderRadius: BorderRadius.all(Radius.circular(30),),
                            borderSide: BorderSide(
                                style: BorderStyle.none, color: Colors.blue)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 90,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(249, 139, 245, 144),
                      ),
                      child: const Center(
                        child: Text(
                          'search',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 1,
              child: InventoryTable(),
            ),
          ],
        ),
      ),
    );
  }
}
