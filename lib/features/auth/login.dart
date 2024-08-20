import 'dart:developer';

import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budgetpal/features/auth/signup.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    Text(
                      'BudgetPal',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Login to your account',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.045,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.08),
                    _buildEmailField(size),
                    SizedBox(height: size.height * 0.03),
                    _buildPasswordField(size),
                    SizedBox(height: size.height * 0.02),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: size.width * 0.035,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue[800],
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(fontSize: size.width * 0.045),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: size.width * 0.035,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.lato(
          color: Colors.blue[800],
          fontSize: size.width * 0.04,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.05,
          ),
          border: InputBorder.none,
          hintText: 'Email',
          hintStyle: GoogleFonts.lato(
            color: Colors.blue[800]!.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.blue[800],
            size: size.width * 0.06,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: GoogleFonts.lato(
          color: Colors.blue[800],
          fontSize: size.width * 0.04,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.05,
          ),
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle: GoogleFonts.lato(
            color: Colors.blue[800]!.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.blue[800],
            size: size.width * 0.06,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.blue[800],
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // print('Email: $email---Password: $password');

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final authController =
            Provider.of<AuthController>(context, listen: false);
        final authResponse = await authController.login(email, password);

        Navigator.pop(context);

        if (authResponse == false) {
          // Handle authentication error
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Invalid credentials, check your email and password and try again!"),
          ));
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong. Please try again later."),
        ));
        log(e.toString());
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
