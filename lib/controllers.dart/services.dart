// import 'dart:developer';

// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String ACCESS_TOKEN = "access_token";

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final dio = Dio();
    final client = RestClient(dio);
    try {
      Map<String, String> user = {"email": email, "password": password};
      final response = await client.signIn(body: user);

      if (response.containsKey('data') &&
          response['data'].containsKey('token')) {
        final accessToken = response['data']['token'];
        await saveAccessToken(accessToken);
        await saveUserDetails(
            response['data']['data']['name'],
            response['data']['data']['email'],
            response['data']['data']['age'],
            response['data']['data']['phone_number']);
        return response;
      } else {
        return {
          "error": "Invalid credentials",
          "status": "error",
        };
      } // Handle the case when the access token is not present in the response
    } catch (e) {
      return {
        "error": "Ran into a technical problem",
        "status": "error",
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email,
      String password, String phoneNumber, int age) async {
    final dio = Dio();
    final client = RestClient(dio);
    dio.options.headers['Accept'] = "application/json";
    try {
      Map<String, String> user = {
        "name": name,
        "email": email,
        "password": password,
        "phone_number": phoneNumber,
        "age": age.toString(),
      };
      final response = await client.signUp(body: user);

      //check if the response contains message key
      if (response.containsKey('message')) {
        return response;
      } else {
        return {
          "error": "Invalid credentials",
          "status": "error",
        };
      }
    } catch (e) {
      print("save error: $e");
      return {
        "error": "Invalid credentials",
        "status": "error",
      };
    }
  }

  //save access token to shared preferences
  saveAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN, accessToken);
  }

  saveUserDetails(
      String name, String email, String age, String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("phone_number", phoneNumber);
    await prefs.setString("age", age);
  }

  getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(ACCESS_TOKEN)) {
      return "";
    }
    return prefs.getString(ACCESS_TOKEN);
  }

  //get user details from shared preferences
  // Future<Map<String, dynamic>> getUserDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey("name") ||
  //       !prefs.containsKey("email") ||
  //       !prefs.containsKey("role")) {
  //     return {
  //       "name": "",
  //       "email": "",
  //       "role": "",
  //     };
  //   }
  //   return {
  //     "name": prefs.getString("name"),
  //     "email": prefs.getString("email"),
  //     "role": prefs.getString("role"),
  //   };
  // }

  removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN);
  }

  Future<Map<String, dynamic>> signOut() async {
    final dio = Dio();
    final client = RestClient(dio);
    dio.options.headers['Authorization'] = "Token ${await getAccessToken()}";
    dio.options.headers['Accept'] = "application/json";
    try {
      final response = await client.signOut();
      if (response['status'] == 'success') {
        await removeAccessToken();
        return response;
      } else {
        return {
          "error": "Failed to sign out",
          "status": response['status'],
        };
      }
    } catch (e) {
      return {
        "error": "Ran into a technical error",
        "status": "error",
      };
    }
  }

  Future<Map<String, dynamic>> getUsers() async {
    final dio = Dio();
    final client = RestClient(dio);
    dio.options.headers['Authorization'] = "Token ${await getAccessToken()}";
    try {
      final response = await client.getUsers();
      if (response['status'] == 'success') {
        return {
          "data": response['data'],
          "status": response['status'],
        };
      } else {
        return {
          "error": "Failing to get users",
          "status": response['status'],
        };
      }
    } catch (e) {
      return {
        "error": "Ran into a technical error",
        "status": "error",
      };
    }
  }
}
