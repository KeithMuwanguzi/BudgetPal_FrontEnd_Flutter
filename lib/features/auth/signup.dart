import 'package:budgetpal/features/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTextField(
                    icon: Icons.email,
                    hintText: 'Email',
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTextField(
                    icon: Icons.contact_mail,
                    hintText: 'Phone Number',
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTextField(
                    icon: Icons.calculate,
                    hintText: 'Age',
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTextField(
                    icon: Icons.lock,
                    hintText: 'Password',
                    isPassword: true,
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildTextField(
                    icon: Icons.lock,
                    hintText: 'Confirm Password',
                    isPassword: true,
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.04),
                  ElevatedButton(
                    onPressed: () {},
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
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    required Size size,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        obscureText: isPassword,
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
      ),
    );
  }
}
