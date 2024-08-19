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

  // Future<bool> register(String email, String password, String fullName) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await _apiService.register(email, password, fullName);
  //     _token = response['token'];
  //     _isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

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

  getBalances() async {
    _isLoading = true;
    notifyListeners();
    String token = await getAccessToken();

    try {
      final response = await _apiService.getTotals(token);
      _isLoading = false;
      notifyListeners();
      return {'balance': response['data']['income_total']};
    } catch (e) {
      log('Logout error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
