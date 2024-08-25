import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salesmart/components/chartCard.dart';
import 'package:salesmart/components/metricCard.dart';
import 'package:salesmart/components/transaction.dart';
import 'package:salesmart/screens/inventorypage.dart';
import 'package:salesmart/screens/transactionspage.dart';
import 'package:salesmart/screens/analytics.dart';
import 'package:salesmart/screens/login_shop.dart';
import 'package:salesmart/services/top_products.dart'; // Import the ApiService
import 'package:salesmart/services/sales_trends.dart';
import 'package:salesmart/services/attendant_details.dart';
import 'package:salesmart/services/sales_summaries.dart';

class DashboardPageAttendant extends StatefulWidget {
  @override
  _DashboardPageAttendantState createState() => _DashboardPageAttendantState();
}

class _DashboardPageAttendantState extends State<DashboardPageAttendant> {
  late Future<Map<String, dynamic>> topProductsData;
  late Future<Map<String, dynamic>> salesTrendData;
  late String attendant_name;
  late String profit;
  late String number_of_transactions;
  late String transactions;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    String token = 'YOUR_JWT_TOKEN'; // Implement a way to get the current token
    topProductsData = ApiService.fetchTopProducts('week', token);
    salesTrendData = ApiService.fetchTopProducts(
        'month', token); // Assuming you want monthly data for sales trend
  }

  void _TrendData() {
    String token = 'YOUR_JWT_TOKEN'; // Implement a way to get the current token
    salesTrendData = ApiTrendService.fetchDailySales(token);
  }

  void getAttendantDetails(String token) async {
    try {
      final details = await ApiProfileService.fetchShopDetails(token);

      if (details.containsKey('shopName')) {
        attendant_name = details['name'];

        // Update your UI or perform further actions
      } else if (details.containsKey('msg')) {
        print('Error: ${details['msg']}');
        // Handle the error case
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
      transactions = summary['totalTransactionValue'];
      number_of_transactions = summary['number_of_transactions'];
      profit = summary['total_profits'];
      // Update your UI or perform further actions
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
            //_buildTransactionsPreview(context),
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
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => InventoryPage())),
          ),
          _buildDrawerItem(
            icon: Icons.monetization_on,
            text: 'Transactions',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TransactionsPage())),
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            text: 'Reports & Analytics',
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AnalyticsPage())),
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
            text: 'Settings',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginShop())),
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
                  attendant_name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const Text('Attendant',
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
          value: '₵ $transactions',
          icon: const Icon(Icons.wallet, size: 20, color: Colors.blue),
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          title: 'Today\'s Profit',
          color: const Color.fromARGB(255, 243, 249, 121),
          icon: const Icon(Icons.monetization_on_rounded,
              size: 20, color: Colors.blue),
          value: '₵ $profit',
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          title: 'Number of transactions today',
          color: const Color.fromARGB(253, 200, 244, 249),
          icon: const Icon(Icons.arrow_upward, size: 20, color: Colors.blue),
          value: number_of_transactions,
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.14,
        ),
        MetricCard(
          color: const Color.fromARGB(251, 250, 206, 210),
          title: 'Today\'s transactions',
          icon: const Icon(Icons.wallet, size: 20, color: Colors.blue),
          value: '₵ $transactions',
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
            topProductsData,
            500.0,
            350.0,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildChartCard(
            "Sales Trend",
            salesTrendData,
            1100.0,
            350.0,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, Future<Map<String, dynamic>> futureData,
      double width, double height) {
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
            FutureBuilder<Map<String, dynamic>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Container(
                    width: width,
                    height: height,
                    child: SalesBarChart(
                      productNames:
                          List<String>.from(data['productNames'] ?? []),
                      salesNumbers: List<int>.from(data['salesNumbers'] ?? []),
                      max: (data['max'] as num?)?.toDouble() ?? 0.0,
                    ),
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTransactionsPreview(BuildContext context) {
  //   return Column(
  //     children: [
  //       const Center(
  //         heightFactor: 3,
  //         child: Text(
  //           'Transactions preview',
  //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //       Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.height * 0.5,
  //         child: TransactionTable(),
  //       ),
  //     ],
  //   );
  // }
}
