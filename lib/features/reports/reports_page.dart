import 'package:budgetpal/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Report> reports = [
    Report(
      id: 1,
      title: 'Monthly Expense Report',
      generatedDate: DateTime.now().subtract(const Duration(days: 1)),
      type: 'Expense',
      data: {
        'Food': 500,
        'Transportation': 200,
        'Entertainment': 150,
        'Utilities': 300,
      },
    ),
    Report(
      id: 2,
      title: 'Income vs Expense',
      generatedDate: DateTime.now().subtract(const Duration(days: 7)),
      type: 'Comparison',
      data: {
        'Income': 3000,
        'Expense': 2500,
      },
    ),
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
          'Reports',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return _buildReportCard(report);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showGenerateReportDialog();
        },
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.title, style: Theme.of(context).textTheme.headline6),
            Text(
                'Generated on: ${DateFormat('yyyy-MM-dd').format(report.generatedDate)}'),
            const SizedBox(height: 20),
            if (report.type == 'Expense')
              _buildExpensePieChart(report.data)
            else if (report.type == 'Comparison')
              _buildComparisonBarChart(report.data),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Export PDF'),
                  onPressed: () {
                    _exportReportToPDF(report);
                  },
                ),
                TextButton(
                  child: const Text('Share'),
                  onPressed: () {
                    _shareReport(report);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensePieChart(Map<String, dynamic> data) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.entries
              .map((entry) => PieChartSectionData(
                    value: entry.value.toDouble(),
                    title: entry.key,
                    color: Colors.primaries[
                        data.keys.toList().indexOf(entry.key) %
                            Colors.primaries.length],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildComparisonBarChart(Map<String, dynamic> data) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.values.reduce((a, b) => a > b ? a : b).toDouble(),
          titlesData: const FlTitlesData(show: true),
          barGroups: data.entries
              .map((entry) => BarChartGroupData(
                    x: data.keys.toList().indexOf(entry.key),
                    barRods: [
                      BarChartRodData(fromY: entry.value.toDouble(), toY: 0)
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showGenerateReportDialog() {
    // Implement generate report dialog
  }

  void _exportReportToPDF(Report report) {
    // Implement PDF export functionality
  }

  void _shareReport(Report report) {
    // Implement share functionality
  }
}
