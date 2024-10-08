// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:budgetpal/controllers/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? accessToken;
  bool _isLoading = false;
  static String ACCESS_TOKEN = "access_token";

  bool get isLoading => _isLoading;

  saveAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN, accessToken);
  }

  saveUserDetails(String name, String email, String phone, int age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("age", age.toString());
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("phone", phone);
  }

  removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("name");
    await prefs.remove("phone");
    await prefs.remove("age");
    await prefs.remove("email");
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(ACCESS_TOKEN)) {
      return "";
    }
    return prefs.getString(ACCESS_TOKEN);
  }

  removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN);
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      accessToken = response['data']['token'];
      log(accessToken.toString());
      saveAccessToken(accessToken.toString());
      saveUserDetails(
          response['data']['data']['name'],
          response['data']['data']['email'],
          response['data']['data']['phone_number'],
          response['data']['data']['age']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String name, String phone, int age) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.register(email, password, name, phone, age);
      if (response['status'] != 'error') {
        accessToken = response['data']['token'];
        log(accessToken.toString());
        saveAccessToken(accessToken.toString());
        saveUserDetails(
            response['data']['data']['name'],
            response['data']['data']['email'],
            response['data']['data']['phone_number'],
            response['data']['data']['age']);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
      await removeAccessToken();
      await removeUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      log('Logout error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> getExpTotals() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        return {'status': 'error', 'error': 'No token found'};
      }

      Map<String, dynamic> response = await ApiService().getExpTotals(token);

      if (response['message'] == 'Analytics fetched') {
        return {'status': 'success', 'data': response['data'] ?? []};
      } else {
        return {'status': 'error', 'error': 'Failed to fetch analytics'};
      }
    } catch (e) {
      log('Error fetching analytics: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteBudget(int budgetId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        return {'status': 'error', 'error': 'No token found'};
      }

      Map<String, dynamic> response =
          await ApiService().deleteBudget(token, budgetId);

      if (response['message'] == 'Budget deleted successfully') {
        return {'status': 'success', 'message': 'Budget deleted successfully'};
      } else {
        return {'status': 'error', 'error': 'Failed to delete budget'};
      }
    } catch (e) {
      log('Error deleting budget: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> editBudget(
      int budgetId, Map<String, dynamic> budgetData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        return {'status': 'error', 'error': 'No token found'};
      }

      Map<String, dynamic> response =
          await ApiService().editBudget(token, budgetId, budgetData);

      if (response.containsKey('error')) {
        return {'status': 'error', 'error': 'Failed to update budget'};
      } else {
        return {'status': 'success', 'data': response};
      }
    } catch (e) {
      log('Error editing budget: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      Map<String, dynamic> response = await ApiService().getIncomes(token);

      if (response['message'] == 'All income items fetched') {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception('Failed to fetch incomes');
      }
    } catch (e) {
      print('Error fetching incomes: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      Map<String, dynamic> response = await ApiService().getBudgets(token);

      if (response['message'] == 'All budgets fetched') {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception('Failed to fetch incomes');
      }
    } catch (e) {
      print('Error fetching incomes: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getBalances() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        return {'status': 'error', 'error': 'No token found'};
      }

      Map<String, dynamic> response = await ApiService().getTotals(token);

      if (response['message'] == 'Analytics fetched') {
        return {
          'status': 'success',
          'balance': response['data']['income_total'] ?? 0
        };
      } else {
        return {'status': 'error', 'error': 'Failed to fetch analytics'};
      }
    } catch (e) {
      log('Error fetching analytics: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      Map<String, dynamic> response = await ApiService().getExpenses(token);

      if (response['message'] == 'All expense items fetched') {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception('Failed to fetch expenses');
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  // In authcontroller.dart

  Future<void> addIncome(Map<String, dynamic> incomeData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      await ApiService().addIncome(token, incomeData);
    } catch (e) {
      print('Error adding income: $e');
      throw e;
    }
  }

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      await ApiService().addExpense(token, expenseData);
    } catch (e) {
      print('Error adding expense: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> addBudget(
      Map<String, dynamic> budgetData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('No token found');
      }

      Map<String, dynamic> response =
          await ApiService().addBudget(token, budgetData);
      if (response['status'] == 'success') {
        return response;
      } else {
        return {'status': 'error', 'error': response['error']};
      }
    } catch (e) {
      return {'status': 'error', 'error': e};
    }
  }
}
