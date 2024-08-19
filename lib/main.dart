// ignore: unused_import
import 'package:budgetpal/controllers/authcontroller.dart';
import 'package:budgetpal/features/auth/login.dart';
import 'package:budgetpal/features/home/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgetpal/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:budgetpal/features/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLaunch = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setValue().then((isFirstLaunch) {
      setState(() {
        this.isFirstLaunch = isFirstLaunch;
        isLoading = false;
      });
    });
  }

  Future<bool> setValue() async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);
    if (launchCount == 0) {
      // If it's the first launch, return true.
      return true;
    } else {
      // If it's not the first launch, return false.
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget Pal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLoading
            ? const Scaffold(
                backgroundColor:
                    Colors.white, // Set the background color to white
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue, // Set the color of the spinner
                    ),
                  ),
                ),
              )
            : isFirstLaunch
                ? const WelcomePage()
                : Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      auth.isLoggedIn();
                      return auth.isAuthenticated
                          ? const HomePage()
                          : const LoginPage();
                    },
                  ),
        routes: {
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}
