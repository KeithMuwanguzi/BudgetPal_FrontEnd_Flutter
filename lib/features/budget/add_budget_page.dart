import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String? _selectedCategory;
  AuthController controller = AuthController();

  final List<String> _categories = ['Necessities', 'Leisure', 'Others'];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // All fields are valid, create the budget data
      final budgetData = {
        'name': _nameController.text.trim(),
        'amount': double.parse(_amountController.text.trim()),
        'start_date': _startDateController.text,
        'end_date': _endDateController.text,
        'category': _selectedCategory,
      };

      var response = await controller.addBudget(budgetData);

      if (response['status'] == 'success') {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budget added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occured!,Budget not added'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Show a success message

      // Clear the form
      _formKey.currentState!.reset();
      _nameController.clear();
      _amountController.clear();
      _startDateController.clear();
      _endDateController.clear();
      setState(() {
        _selectedCategory = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(
          'Add Budget',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Budget Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a budget name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _startDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _endDateController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an end date';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Budget'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
