import 'package:budgetpal/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<Goal> goals = [
    Goal(
        id: 1,
        name: 'Vacation Fund',
        targetAmount: 5000,
        currentAmount: 2500,
        targetDate: DateTime.now().add(const Duration(days: 180))),
    Goal(
        id: 2,
        name: 'New Laptop',
        targetAmount: 1500,
        currentAmount: 750,
        targetDate: DateTime.now().add(const Duration(days: 90))),
    Goal(
        id: 3,
        name: 'Emergency Fund',
        targetAmount: 10000,
        currentAmount: 7500,
        targetDate: DateTime.now().add(const Duration(days: 365))),
  ];

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
          'Financial Goals',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return _buildGoalCard(goal);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddGoalDialog();
        },
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final progress = goal.currentAmount / goal.targetAmount;
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.name, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 20,
              percent: progress,
              center: Text('${(progress * 100).toStringAsFixed(1)}%'),
              progressColor: Colors.blue,
              backgroundColor: Colors.blue.shade100,
            ),
            const SizedBox(height: 10),
            Text('Target: \$${goal.targetAmount.toStringAsFixed(2)}'),
            Text('Current: \$${goal.currentAmount.toStringAsFixed(2)}'),
            Text('Days left: $daysLeft'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text('Add Funds'),
                  onPressed: () {
                    _showAddFundsDialog(goal);
                  },
                ),
                OutlinedButton(
                  child: const Text('Adjust Goal'),
                  onPressed: () {
                    _showAdjustGoalDialog(goal);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    // Implement add goal dialog
  }

  void _showAddFundsDialog(Goal goal) {
    // Implement add funds dialog
  }

  void _showAdjustGoalDialog(Goal goal) {
    // Implement adjust goal dialog
  }
}
