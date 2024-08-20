// In incomes_page.dart

import 'package:budgetpal/features/income/add_income_page.dart';
import 'package:flutter/material.dart';
import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({super.key});

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _incomes = [];
  bool _isLoading = true;
  final NumberFormat _formatter = NumberFormat("#,##0");

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> incomes = await _authController.getIncomes();
      setState(() {
        _incomes = incomes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading incomes: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load incomes. Please try again.')),
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
          'Incomes',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: RefreshIndicator(
        onRefresh: _loadIncomes,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _incomes.isEmpty
                ? const Center(child: Text('No incomes found'))
                : ListView.builder(
                    itemCount: _incomes.length,
                    itemBuilder: (context, index) {
                      final income = _incomes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            income['category'],
                            style:
                                GoogleFonts.lato(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            income['description'] ??
                                "${income['category']} as of ${income['date']}",
                            style: GoogleFonts.lato(),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'UGX ${_formatter.format(double.parse(income['amount']))}',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                income['date'],
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
            MaterialPageRoute(builder: (context) => const AddIncomePage()),
          );
          if (result == true) {
            // Income was added successfully, refresh the list
            _loadIncomes();
          }
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}
