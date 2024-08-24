import 'package:budgetpal/features/auth/login.dart';
import 'package:budgetpal/features/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to BudgetPal',
                  style: GoogleFonts.lato(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Your personal finance companion',
                  style: GoogleFonts.lato(
                    fontSize: size.width * 0.045,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.06),
                _buildInfoCard(
                  size: size,
                  icon: Icons.account_balance_wallet,
                  title: 'Track Expenses',
                  description: 'Monitor your spending habits effortlessly',
                ),
                SizedBox(height: size.height * 0.02),
                _buildInfoCard(
                  size: size,
                  icon: Icons.trending_up,
                  title: 'Set Goals',
                  description: 'Plan and achieve your financial objectives',
                ),
                SizedBox(height: size.height * 0.02),
                _buildInfoCard(
                  size: size,
                  icon: Icons.insights,
                  title: 'Insightful Analytics',
                  description: 'Gain valuable insights into your finances',
                ),
                SizedBox(height: size.height * 0.06),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue[800],
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    textStyle: GoogleFonts.lato(fontSize: size.width * 0.045),
                  ),
                  child: const Text('Get Started'),
                ),
                SizedBox(height: size.height * 0.02),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    textStyle: GoogleFonts.lato(fontSize: size.width * 0.045),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required Size size,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Row(
          children: [
            Icon(icon, size: size.width * 0.1, color: Colors.blue[800]),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    description,
                    style: GoogleFonts.lato(
                      fontSize: size.width * 0.035,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
