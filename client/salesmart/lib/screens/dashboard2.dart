import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/chartCard.dart';
import 'package:salesmart/components/metricCard.dart';
import 'package:salesmart/screens/inventorypage.dart';
import 'package:salesmart/screens/loginas.dart';
import 'package:salesmart/screens/transactionspage.dart';
import 'package:salesmart/screens/analytics.dart';
import 'package:salesmart/services/top_products.dart';
import 'package:salesmart/services/sales_trends.dart';
import 'package:salesmart/services/attendant_details.dart';
import 'package:salesmart/services/sales_summaries.dart';
import 'package:salesmart/screens/create_attendant_account.dart';
import 'package:salesmart/components/analticsbarchart.dart';
import 'package:salesmart/components/newtrends.dart'; // Make sure this path is correct

class DashboardPageManager extends StatefulWidget {
  final String token;

  const DashboardPageManager({Key? key, required this.token}) : super(key: key);

  @override
  _DashboardPageManagerState createState() => _DashboardPageManagerState();
}

class _DashboardPageManagerState extends State<DashboardPageManager> {
  late String manager_name = '';
  late String profit = '...';
  late String number_of_transactions = '....';
  late String transactions = '...';
  final String no_trans = '4';

  @override
  void initState() {
    super.initState();
    getManagerDetails(widget.token);
    getDailySummary(widget.token);
  }

  void getManagerDetails(String token) async {
    try {
      final details = await ApiProfileService.fetchShopDetails(token);

      if (details.containsKey('shopName')) {
        setState(() {
          manager_name = details['name'];
        });
      } else if (details.containsKey('msg')) {
        print('Error: ${details['msg']}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void getDailySummary(String token) async {
    final Map<String, dynamic> summary =
        await ApiSummaryService.fetchDailySummary(token);

    if (summary.containsKey('error')) {
      print('Error: ${summary['error']}');
      if (summary.containsKey('details')) {
        print('Details: ${summary['details']}');
      }
    } else {
      setState(() {
        transactions = summary['totalTransactionValue'].toString();
        number_of_transactions = summary['number_of_transactions'].toString();
        profit = summary['total_profits'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 50),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Text("SaleSmart",
            style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black))),
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
              color: Colors.green),
        ),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSummaryCards(context),
            const SizedBox(height: 20),
            _buildCharts(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(context),
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            onTap: () => Navigator.of(context).pop(),
          ),
          _buildDrawerItem(
            icon: Icons.inventory,
            text: 'Inventory',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InventoryPage(token: widget.token))),
          ),
          _buildDrawerItem(
            icon: Icons.monetization_on,
            text: 'Transactions',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TransactionsPage(token: widget.token))),
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            text: 'Reports & Analytics',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AnalyticsPage(token: widget.token))),
          ),
          _buildDrawerItem(
            icon: Icons.notification_add,
            text: 'Notifications',
            onTap: () {},
            trailing: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red,
              child: Text("8",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Switch Account',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LogInAsPage(
                      token: widget.token,
                    ))),
          ),
          _buildDrawerItem(
            icon: Icons.help,
            text: 'Add attendant',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddAttendant(token: widget.token))),
          ),
          _buildDrawerItem(
            icon: Icons.help,
            text: 'Help & Support',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  manager_name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const Text('Manager',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.black),
      title: Text(text,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MetricCard(
          color: const Color.fromARGB(249, 159, 245, 205),
          title: 'Today\'s transactions',
          value: 'GH₵ 419.00',
          icon: const Icon(Icons.wallet, size: 20, color: Colors.blue),
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          title: 'Today\'s Profit',
          color: const Color.fromARGB(255, 243, 249, 121),
          icon: const Icon(Icons.monetization_on_rounded,
              size: 20, color: Colors.blue),
          value: '₵ 75.00',
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          title: 'Number of transactions today',
          color: const Color.fromARGB(253, 200, 244, 249),
          icon: const Icon(Icons.arrow_upward, size: 20, color: Colors.blue),
          value: no_trans,
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          color: const Color.fromARGB(251, 250, 206, 210),
          title: 'Today\'s transactions',
          icon: const Icon(Icons.wallet, size: 20, color: Colors.blue),
          value: 'GH₵419.00',
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
      ],
    );
  }

  Widget _buildCharts() {
    return Row(
      children: [
        Expanded(
          child: _buildChartCard(
            "Top 5 most Purchased Products",
            500.0,
            350.0,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildChartCard(
            "Daily Sales Trend",
            1100.0,
            350.0,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, double width, double height) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 50),
            if (title == "Daily Sales Trend")
              Container(
                width: width,
                height: height,
                child: DailySalesTrendChart(),
              )
            else
              Container(
                width: width,
                height: height,
                child: SalesBarChartNew(
                  productNames: [
                    'Product A',
                    'Product B',
                    'Product C',
                    'Product D'
                  ],
                  salesNumbers: [100, 75, 140, 90],
                  max: 150.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
