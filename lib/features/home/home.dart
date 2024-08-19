import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:budgetpal/features/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String balance = '0';
  AuthController authController = AuthController();
  final NumberFormat formatter = NumberFormat("#,##0");

  @override
  initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tentName = prefs.getString('name') ?? 'N/A';
    var tents = tentName.split(' ');
    var res = await authController.getBalances();
    setState(() {
      name = tents[0];
      balance = formatter.format(res['balance']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BudgetPal',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(size),
            _buildQuickActions(size),
            _buildSpendingOverview(size),
            _buildRecentTransactions(size),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, $name!',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Current Balance',
            style: GoogleFonts.lato(
                color: Colors.white70, fontSize: size.width * 0.04),
          ),
          Text(
            'UGX.$balance',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.lato(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(size, Icons.add, 'Add Income', Colors.green),
              _buildActionButton(size, Icons.remove, 'Add Expense', Colors.red),
              _buildActionButton(
                  size, Icons.pie_chart, 'View Budget', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      Size size, IconData icon, String label, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
            padding: EdgeInsets.all(size.width * 0.04),
          ),
          child: Icon(icon, size: size.width * 0.08),
        ),
        const SizedBox(height: 5),
        Text(label, style: GoogleFonts.lato(fontSize: size.width * 0.03)),
      ],
    );
  }

  Widget _buildSpendingOverview(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Overview',
            style: GoogleFonts.lato(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: size.height * 0.3,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 40,
                    title: '40%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: 30,
                    title: '30%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 15,
                    title: '15%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.yellow,
                    value: 15,
                    title: '15%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(Size size) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: GoogleFonts.lato(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildTransactionItem(size, 'Grocery Shopping', '-\$50.00',
              Icons.shopping_cart, Colors.red),
          _buildTransactionItem(
              size, 'Salary', '+\$2000.00', Icons.attach_money, Colors.green),
          _buildTransactionItem(size, 'Electricity Bill', '-\$80.00',
              Icons.flash_on, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Size size, String title, String amount, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      trailing: Text(
        amount,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: amount.startsWith('+') ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
