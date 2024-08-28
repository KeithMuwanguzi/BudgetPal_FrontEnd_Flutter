import 'dart:developer';

import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:budgetpal/controllers/transactions.dart';
import 'package:budgetpal/features/expenses/add_expense_page.dart';
import 'package:budgetpal/features/income/add_income_page.dart';
import 'package:budgetpal/features/income/income_page.dart';
import 'package:budgetpal/features/expenses/expenses_page.dart';
import 'package:budgetpal/features/goals/goals_page.dart';
import 'package:budgetpal/features/budget/budget_page.dart';
import 'package:budgetpal/features/reports/reports_page.dart';
import 'package:budgetpal/features/settings/settings_page.dart';
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
  late Transactions transactions;
  List<Transaction> recentTransactions = [];

  String name = '';
  String balance = '0';
  var expData = {};
  AuthController authController = AuthController();
  final NumberFormat formatter = NumberFormat("#,##0");
  double nec = 0.0;
  double lei = 0.0;
  double others = 0.0;

  @override
  void initState() {
    super.initState();
    transactions = Transactions();
    _loadRecentTransactions();
    _loadUserData();
    _loadRecentTransactions();
    log(recentTransactions.toString());
  }

  void _loadRecentTransactions() {
    setState(() {
      recentTransactions = transactions.getRecentTransactions(4);
    });
  }

  _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var tentName = prefs.getString('name') ?? '--';
      var tents = tentName.split(' ');

      var res = await authController.getBalances();
      var data = await authController.getExpTotals();

      setState(() {
        name = tents.isNotEmpty ? tents[0] : '--';
        balance = res['status'] == 'success'
            ? formatter.format(res['balance'] ?? 0)
            : '0';
        expData = data['status'] == 'success' ? data['data'] : [];
        nec = expData['necessities'] ?? 0.0;
        others = expData['others'] ?? 0.0;
        lei = expData['leisure'] ?? 0.0;
        _loadRecentTransactions();
      });
    } catch (e) {
      log('Error loading user data: $e');
      // Handle the error, maybe show a snackbar to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load user data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
          _loadRecentTransactions();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(size),
              _buildQuickActions(size),
              _buildSpendingOverview(size),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
            child: Text(
              'BudgetPal',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Income'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IncomesPage()),
              );

              if (result) {
                _loadUserData();
                _loadRecentTransactions();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_off),
            title: const Text('Expenses'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpensesPage()),
              );

              if (result) {
                _loadUserData();
                _loadRecentTransactions();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Goals'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoalsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text('Budget'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BudgetPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reports'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
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
              _buildActionButton(size, Icons.add, 'Add Income', Colors.green,
                  () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddIncomePage()));
                if (result) {
                  _loadUserData();
                  _loadRecentTransactions();
                }
              }),
              _buildActionButton(size, Icons.remove, 'Add Expense', Colors.red,
                  () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddExpensePage()));
                if (result) {
                  _loadUserData();
                  _loadRecentTransactions();
                }
              }),
              _buildActionButton(
                  size, Icons.pie_chart, 'View Budget', Colors.orange, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BudgetPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Size size, IconData icon, String label, Color color,
      VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
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
    double necessities = (expData['necessities'] ?? 0).toDouble();
    double leisure = (expData['leisure'] ?? 0).toDouble();
    double others = (expData['others'] ?? 0).toDouble();
    double total =
        (expData['expenditure'] ?? 1).toDouble(); // Avoid division by zero

    // If total is 0, set each section to 0
    double necessitiesPercentage = total > 0 ? (necessities / total) * 100 : 0;
    double leisurePercentage = total > 0 ? (leisure / total) * 100 : 0;
    double othersPercentage = total > 0 ? (others / total) * 100 : 0;

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
          SizedBox(
            height: size.height * 0.3,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: necessitiesPercentage,
                    title: '${necessitiesPercentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: leisurePercentage,
                    title: '${leisurePercentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: othersPercentage,
                    title: '${othersPercentage.toStringAsFixed(1)}%',
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
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Necessities', Colors.blue),
        _buildLegendItem('Leisure', Colors.green),
        _buildLegendItem('Others', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    if (recentTransactions.isEmpty) {
      return const Center(child: Text('No transactions available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          child: Text(
            'Recent Transactions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ...recentTransactions.map((tx) {
          return ListTile(
              leading: Icon(
                tx.isIncome ? Icons.attach_money : Icons.shopping_cart,
                color: tx.isIncome ? Colors.green : Colors.red,
              ),
              title: Text(tx.title),
              subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(tx.date)),
              trailing: tx.isIncome
                  ? Text(
                      '${tx.amount.toStringAsFixed(2)} UGX',
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    )
                  : Text(
                      '-${tx.amount.toStringAsFixed(2)} UGX',
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ));
        }),
      ],
    );
  }
}
