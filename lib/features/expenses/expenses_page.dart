import 'package:budgetpal/features/expenses/add_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _expenses = [];
  bool _isLoading = true;
  final NumberFormat _formatter = NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> incomes = await _authController.getExpenses();
      setState(() {
        _expenses = incomes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading expenses: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load expenses. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(
          'Expenses',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _expenses.isEmpty
                ? const Center(child: Text('No expenses found'))
                : ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            expense['category'],
                            style:
                                GoogleFonts.lato(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            expense['description'] ??
                                "${expense['category']} as of ${expense['date']}",
                            style: GoogleFonts.lato(),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '- UGX ${_formatter.format(double.parse(expense['amount']))}',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                expense['date'],
                                style: GoogleFonts.lato(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
          if (result == true) {
            // Income was added successfully, refresh the list
            _loadExpenses();
          }
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}
