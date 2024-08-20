import 'package:budgetpal/controllers/authcontroller.dart';
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
  String name = '';
  String balance = '0';
  AuthController authController = AuthController();
  final NumberFormat formatter = NumberFormat("#,##0");
  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRecentTransactions();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tentName = prefs.getString('name') ?? '--';
    var tents = tentName.split(' ');
    var res = await authController.getBalances();
    setState(() {
      name = tents[0];
      balance = formatter.format(res['balance']);
    });
  }

  _loadRecentTransactions() async {
    // This would typically be a call to your backend or local database
    setState(() {
      recentTransactions = [
        {
          'title': 'Grocery Shopping',
          'amount': -50000,
          'icon': Icons.shopping_cart,
          'color': Colors.red
        },
        {
          'title': 'Salary',
          'amount': 2000000,
          'icon': Icons.attach_money,
          'color': Colors.green
        },
        {
          'title': 'Electricity Bill',
          'amount': -80000,
          'icon': Icons.flash_on,
          'color': Colors.orange
        },
      ];
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
          await _loadRecentTransactions();
        },
        child: SingleChildScrollView(
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
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_off),
            title: const Text('Expenses'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpensesPage()),
              );
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
                }
              }),
              _buildActionButton(size, Icons.remove, 'Add Expense', Colors.red,
                  () {
                _showAddTransactionDialog(context, isIncome: false);
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
          ...recentTransactions
              .map((transaction) => _buildTransactionItem(
                  size,
                  transaction['title'],
                  transaction['amount'],
                  transaction['icon'],
                  transaction['color']))
              .toList(),
          TextButton(
            onPressed: () {
              // TODO: Navigate to full transaction history
            },
            child: const Text('View All Transactions'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Size size, String title, int amount, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      trailing: Text(
        '${amount > 0 ? '+' : ''}${formatter.format(amount)}',
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: amount > 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, {bool isIncome = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isIncome ? 'Add Income' : 'Add Expense'),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: "Title"),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                // Add more fields as needed (e.g., date, category)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // TODO: Implement adding transaction
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
