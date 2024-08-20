import 'dart:developer';

import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:budgetpal/features/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfPassword = true;
  final _formKey = GlobalKey<FormState>();

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
                    SizedBox(height: size.height * 0.08),
                    Text(
                      'Create Account',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Join BudgetPal and take control of your finances',
                      style: GoogleFonts.lato(
                        fontSize: size.width * 0.04,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.06),
                    _buildTextField(
                      icon: Icons.person,
                      hintText: 'Full Name',
                      size: size,
                      controller: _nameController,
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildEmailField(size),
                    SizedBox(height: size.height * 0.02),
                    _buildTextField(
                      icon: Icons.contact_mail,
                      hintText: 'Phone Number',
                      size: size,
                      controller: _phoneController,
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildTextField(
                      icon: Icons.calculate,
                      hintText: 'Age',
                      size: size,
                      controller: _ageController,
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildPasswordField(size: size, hint: 'Password'),
                    SizedBox(height: size.height * 0.02),
                    _buildConfirmPasswordField(
                        size: size, hint: 'Confirm Password'),
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
                        'Sign Up',
                        style: GoogleFonts.lato(fontSize: size.width * 0.045),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
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
                                    builder: (context) => const LoginPage()));
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'By signing up, you agree to our Terms of Service and Privacy Policy',
                      style: GoogleFonts.lato(
                        color: Colors.white70,
                        fontSize: size.width * 0.03,
                      ),
                      textAlign: TextAlign.center,
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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String phone = _phoneController.text.trim();
      int age = int.parse(_ageController.text.trim());
      String name = _nameController.text.trim();

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
        final authResponse =
            await authController.register(email, password, name, phone, age);

        Navigator.pop(context);

        if (authResponse == false) {
          // Handle authentication error
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid credentials, Email already exists!"),
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

  Widget _buildPasswordField({required Size size, required String hint}) {
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
          hintText: hint,
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

  Widget _buildConfirmPasswordField(
      {required Size size, required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _passwordConfirmController,
        obscureText: _obscureConfPassword,
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
          hintText: hint,
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
              _obscureConfPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.blue[800],
            ),
            onPressed: () {
              setState(() {
                _obscureConfPassword = !_obscureConfPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (_passwordConfirmController.text.trim() !=
              _passwordController.text.trim()) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    required Size size,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        obscureText: isPassword,
        controller: controller,
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
          hintText: hintText,
          hintStyle: GoogleFonts.lato(
            color: Colors.blue[800]!.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.blue[800],
            size: size.width * 0.06,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid value';
          }
          return null;
        },
      ),
    );
  }
}
