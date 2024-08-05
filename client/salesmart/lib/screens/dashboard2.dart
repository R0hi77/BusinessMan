import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/chartCard.dart';
import 'package:salesmart/components/metricCard.dart';
import 'dart:math';
import 'package:salesmart/components/transaction.dart';
import 'package:salesmart/screens/inventorypage.dart';
import 'package:salesmart/screens/transactionspage.dart';
import 'package:salesmart/screens/analytics.dart';
import 'package:salesmart/screens/login_shop.dart';

class DashboardPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 50,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.22,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "User's name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Attendant',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
                leading: const Icon(
                  Icons.dashboard,
                  size: 30,
                  color: Colors.black,
                ),
                title: const Text('Dashboard',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                selectedColor: Colors.green,
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            ListTile(
              leading: const Icon(
                Icons.inventory,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'Inventory',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              selectedColor: Colors.green,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => InventoryPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.monetization_on,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'Transactions',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              selectedColor: Colors.black,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TransactionsPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.analytics,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'Reports & Analytics',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              selectedColor: Colors.green,
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnalyticsPage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notification_add,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              selectedColor: Colors.green,
              trailing: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.red,
                child: Center(
                  child: Text("8",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginShop()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
                color: Colors.black,
              ),
              title: const Text(
                'Help & Support',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              onTap: () {},
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.33,
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MetricCard(
                    color: const Color.fromARGB(249, 159, 245, 205),
                    title: 'Today\'s transactions',
                    value: '₵ 200.87',
                    icon:
                        const Icon(Icons.wallet, size: 20, color: Colors.blue),
                    width: MediaQuery.sizeOf(context).width * 0.18,
                    height: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                  MetricCard(
                    title: 'Today\'s Profit',
                    color: const Color.fromARGB(255, 243, 249, 121),
                    icon: const Icon(
                      Icons.monetization_on_rounded,
                      size: 20,
                      color: Colors.blue,
                    ),
                    value: '₵ 26.17',
                    width: MediaQuery.sizeOf(context).width * 0.18,
                    height: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                  MetricCard(
                    title: 'Number of transactions today',
                    color: const Color.fromARGB(253, 200, 244, 249),
                    icon: const Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: Colors.blue,
                    ),
                    value: '28',
                    width: MediaQuery.sizeOf(context).width * 0.18,
                    height: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                  MetricCard(
                    color: const Color.fromARGB(251, 250, 206, 210),
                    title: 'Today\'s transactions',
                    icon: const Icon(
                      Icons.wallet,
                      size: 20,
                      color: Colors.blue,
                    ),
                    value: '₵ 200.87',
                    width: MediaQuery.sizeOf(context).width * 0.18,
                    height: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(49.0, 25, 0, 0),
                    child: Card(
                      // color: Color.fromARGB(210, 225, 233, 235),
                      child: Column(
                        children: [
                          const Text(
                            "Top 5 most Purchased Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                              width: 500,
                              height: 350,
                              child: SalesBarChart(
                                productNames: const [
                                  'Product A',
                                  'Prodcut B',
                                  'Prodcut C',
                                  'Prodcut D',
                                  'Prodcut E'
                                ],
                                salesNumbers: const [4, 13, 9, 16, 9],
                                max: [4, 13, 9].reduce(max).toDouble() + 10,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(110.0, 25, 0, 0),
                    child: Card(
                      // color: Color.fromARGB(210, 225, 233, 235),
                      child: Column(
                        children: [
                          const Text(
                            "Sales Trend",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                              width: 1100,
                              height: 350,
                              child: SalesBarChart(
                                productNames: const [
                                  'Product A',
                                  'Prodcut B',
                                  'Prodcut C',
                                  'Prodcut D',
                                  'Prodcut E'
                                ],
                                salesNumbers: const [4, 13, 9, 16, 9],
                                max: [4, 13, 9].reduce(max).toDouble() + 10,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Client Activity
              const Center(
                heightFactor: 3,
                child: Text(
                  'Transactions preview',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.sizeOf(context).width * 1,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: TransactionTable()),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildClientActivityTable() {
  //   return Card(
  //     child: DataTable(
  //       columns: const [
  //         DataColumn(label: Text('Client ID')),
  //         DataColumn(label: Text('Client Name')),
  //         DataColumn(label: Text('Email')),
  //         DataColumn(label: Text('Phone Number')),
  //         DataColumn(label: Text('Sign-up Date')),
  //         DataColumn(label: Text('Account Type')),
  //         DataColumn(label: Text('Status')),
  //         DataColumn(label: Text('Actions')),
  //       ],
  //       rows: [
  //         _buildClientDataRow('#001', 'Leslie Alexander', 'leslie@acme.com',
  //             '(201) 555-0124', '2023-09-14', 'Regular', 'Active'),
  //         _buildClientDataRow('#002', 'Ronald Richards', 'ronald@summit.com',
  //             '(907) 555-0101', '2023-09-14', 'Premium', 'Pending'),
  //         _buildClientDataRow(
  //             '#003',
  //             'Brooklyn Simmons',
  //             'brooklyn@brightstar.com',
  //             '(209) 555-0104',
  //             '2023-09-13',
  //             'Regular',
  //             'Pending'),
  //         _buildClientDataRow(
  //             '#004',
  //             'Cameron Williamson',
  //             'cameron@zenith.com',
  //             '(207) 555-0119',
  //             '2023-09-12',
  //             'Premium',
  //             'Active'),
  //         _buildClientDataRow('#005', 'Esther Howard', 'esther@abstegro.com',
  //             '(316) 555-0116', '2023-09-12', 'Premium', 'Active'),
  //       ],
  //     ),
  //   );
  // }

  // DataRow _buildClientDataRow(String id, String name, String email,
  //     String phone, String signUpDate, String accountType, String status) {
  //   return DataRow(cells: [
  //     DataCell(Text(id)),
  //     DataCell(Text(name)),
  //     DataCell(Text(email)),
  //     DataCell(Text(phone)),
  //     DataCell(Text(signUpDate)),
  //     DataCell(Text(accountType)),
  //     DataCell(Text(status)),
  //     DataCell(Row(
  //       children: <Widget>[
  //         IconButton(icon: Icon(Icons.edit), onPressed: () {}),
  //         IconButton(icon: Icon(Icons.delete), onPressed: () {}),
  //       ],
  //     )),
  //   ]);
  // }

//   Widget _buildFleetStatusTable() {
//     return Card(
//       child: DataTable(
//         columns: [
//           DataColumn(label: Text('Vehicle ID')),
//           DataColumn(label: Text('Vehicle Type')),
//           DataColumn(label: Text('Current Location')),
//           DataColumn(label: Text('Last Maintenance')),
//           DataColumn(label: Text('Status')),
//           DataColumn(label: Text('Distance (in miles)')),
//           DataColumn(label: Text('Fuel Level (%)')),
//         ],
//         rows: [
//           _buildFleetDataRow('V001', 'Truck', 'Warehouse A', '2023-09-14',
//               'In service', '3,500', '85%'),
//           _buildFleetDataRow('V002', 'Van', 'Route 1', '2023-09-13', 'En route',
//               '1,200', '70%'),
//           _buildFleetDataRow('V003', 'Truck', 'Warehouse B', '2023-09-13',
//               'In service', '4,000', '90%'),
//           _buildFleetDataRow('V004', 'Ship', 'Port 2', '2023-09-12',
//               'Out of service', '-', '-'),
//           _buildFleetDataRow('V005', 'Van', 'Route 3', '2023-09-12',
//               'In service', '1,800', '75%'),
//         ],
//       ),
//     );
//   }

//   DataRow _buildFleetDataRow(String id, String type, String location,
//       String maintenance, String status, String distance, String fuel) {
//     return DataRow(cells: [
//       DataCell(Text(id)),
//       DataCell(Text(type)),
//       DataCell(Text(location)),
//       DataCell(Text(maintenance)),
//       DataCell(Text(status)),
//       DataCell(Text(distance)),
//       DataCell(Text(fuel)),
//     ]);
//   }
// }
}
