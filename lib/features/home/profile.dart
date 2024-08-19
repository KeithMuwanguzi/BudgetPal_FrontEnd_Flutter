import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String phone = '';
  String age = '0';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'N/A';
      email = prefs.getString('email') ?? 'N/A';
      phone = prefs.getString('phone') ?? 'N/A';
      age = prefs.getString('age') ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildInfoSection(),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.lato(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.lato(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            email,
            style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoTile(Icons.phone, 'Phone', phone),
          _buildInfoTile(Icons.cake, 'Age', age.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(Icons.notifications, 'Notifications', () {
            // TODO: Implement notifications settings
          }),
          _buildSettingsTile(Icons.lock, 'Privacy', () {
            // TODO: Implement privacy settings
          }),
          _buildSettingsTile(Icons.help, 'Help & Support', () {
            // TODO: Implement help & support
          }),
          _buildSettingsTile(Icons.exit_to_app, 'Logout', () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
            // Implement logout
            AuthController authController = AuthController();
            bool success = await authController.logout();
            if (success) {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Failed to logout. Please try again.')),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[800]),
      title: Text(title, style: GoogleFonts.lato()),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
