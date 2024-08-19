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

  saveUserDetails(String name, String email, String role, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("id", id.toString());
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("role", role);
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
}
