// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://keithjeyson.pythonanywhere.com';
  static String ACCESS_TOKEN = "access_token";

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(ACCESS_TOKEN)) {
      return "";
    }
    return prefs.getString(ACCESS_TOKEN);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/auth/login/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (response.statusCode == 200) {
      log(response.body);
      return jsonDecode(response.body);
    } else {
      log('Failed to login. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return {'Response': response.body};
    }
  }

  Future<Map<String, dynamic>> deleteBudget(String token, int budgetId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/features/delete_budget/$budgetId/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
    ).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      log('Budget deleted successfully');
      return {'message': 'Budget deleted successfully'};
    } else {
      log('Failed to delete budget. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return {'error': 'Failed to delete budget', 'response': response.body};
    }
  }

  // New method to edit a budget
  Future<Map<String, dynamic>> editBudget(
      String token, int budgetId, Map<String, dynamic> budgetData) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl/features/edit_budget/$budgetId/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(budgetData),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (response.statusCode == 200) {
      log('Budget updated successfully');
      return jsonDecode(response.body);
    } else {
      log('Failed to update budget. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return {'error': 'Failed to update budget', 'response': response.body};
    }
  }

  Future<void> logout() async {
    final token = await getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name, String phone, int age) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'phone_number': phone,
        'age': age
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> getTotals(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/features/income_analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Failed to load transactions', 'data': null};
      }
    } catch (e) {
      log('Error in getTotals: $e');
      return {'message': 'An error occurred', 'data': null};
    }
  }

  Future<Map<String, dynamic>> getExpTotals(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/features/exp_analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Failed to load transactions', 'data': null};
      }
    } catch (e) {
      log('Error in getExpTotals: $e');
      return {'message': 'An error occurred', 'data': null};
    }
  }

  Future<Map<String, dynamic>> getIncomes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/features/income'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Map<String, dynamic>> getBudgets(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/features/budgets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load budgets');
    }
  }

  Future<Map<String, dynamic>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/features/expenses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Map<String, dynamic>> addIncome(
      String token, Map<String, dynamic> transactionData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/features/add_income/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var res = jsonDecode(response.body);
      throw Exception("Failed to add transaction, ${res['error']}");
    }
  }

  Future<Map<String, dynamic>> addExpense(
      String token, Map<String, dynamic> expenseData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/features/add_expense/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(expenseData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add transaction');
    }
  }
}
