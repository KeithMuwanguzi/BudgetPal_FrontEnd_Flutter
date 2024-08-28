import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:budgetpal/features/budget/add_budget_page.dart';
import 'package:budgetpal/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BudgetPage extends StatefulWidget {
  final double nec;
  final double leisure;
  final double others;
  const BudgetPage(
      {super.key,
      required this.nec,
      required this.others,
      required this.leisure});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat formatter = NumberFormat("#,##0");
  AuthController controller = AuthController();

  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // budgets = setList();

    fetchBudgets();
  }

  Future<void> deleteBudget(int id) async {
    var response = await controller.deleteBudget(id);
    if (response['status'] == 'success') {
      fetchBudgets();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Budget deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error occurred, failed to delete budget"),
      ));
    }
  }

  Future<void> fetchBudgets() async {
    try {
      List<Map<String, dynamic>> budgetData = await controller.getBudgets();
      setState(() {
        budgets = budgetData.map((json) => Budget.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error fetching budgets: $e');
      budgets = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
          'Budgets',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Details'),
          ],
        ),
      ),
      body: budgets.isEmpty
          ? const Center(child: Text('No budgets set yet'))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(size),
                _buildDetailsTab(size),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBudgetPage()),
          );
          if (result == true) {
            fetchBudgets();
          }
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Size size) {
    double totalBudget = budgets.fold(0, (sum, budget) => sum + budget.amount);
    double totalSpent = budgets.fold(0, (sum, budget) => sum + budget.spent);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Budget',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.045,
                      ),
                    ),
                    Text(
                      'UGX. ${formatter.format(totalBudget)}',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.038,
                        color: Colors.green[600],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Total Spent',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.045,
                      ),
                    ),
                    Text(
                      'UGX. ${formatter.format(totalSpent)}',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.038,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    LinearProgressIndicator(
                      value: totalSpent / totalBudget,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
                    ),
                    SizedBox(height: size.height * 0.008),
                    Text(
                      '${(totalSpent / totalBudget * 100).toStringAsFixed(1)}% of budget used',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.03,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Text(
              'Budget Breakdown',
              style: GoogleFonts.lato(
                fontSize: size.width * 0.05,
              ),
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.all(size.width * 0.05),
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: size.width * 0.11,
                sections: budgets.map((budget) {
                  final index = budgets.indexOf(budget);
                  return PieChartSectionData(
                    color: Colors.primaries[index % Colors.primaries.length],
                    value: budget.amount,
                    title:
                        '${budget.category}\n${(budget.amount / totalBudget * 100).toStringAsFixed(1)}%',
                    radius: size.width * 0.25,
                    titleStyle: GoogleFonts.lato(
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Colors.primaries[index % Colors.primaries.length],
                  child: const Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text(
                  budget.category,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    '${formatter.format(budget.spent)} / ${formatter.format(budget.amount)}',
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.03,
                    )),
                trailing: Text(
                    '${(budget.spent / budget.amount * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.03,
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(Size size) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        final budget = budgets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(budget.category,
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Budget: UGX. ${formatter.format(budget.amount)}',
                  style: GoogleFonts.lato(
                    fontSize: size.width * 0.034,
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                Text('Spent: UGX. ${formatter.format(budget.spent)}',
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.034,
                    )),
                SizedBox(height: size.height * 0.06),
                LinearProgressIndicator(
                  value: budget.spent / budget.amount,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[500]!),
                ),
                SizedBox(height: size.height * 0.006),
                Text(
                  '${(budget.spent / budget.amount * 100).toStringAsFixed(1)}% of budget used',
                  style: GoogleFonts.lato(
                    fontSize: size.width * 0.026,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Edit',
                        style: GoogleFonts.lato(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _showEditBudgetDialog(budget);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Delete',
                        style: GoogleFonts.lato(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _showDeleteBudgetDialog(budget);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditBudgetDialog(Budget budget) {
    // Implement edit budget dialog
  }

  void _showDeleteBudgetDialog(Budget budget) {
    deleteBudget(budget.id);
  }
}
