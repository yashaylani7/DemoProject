import 'package:flutter/material.dart';
import 'package:projectsub/screens/otp.dart';
import 'screens/splashscreen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/landing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen
        '/login': (context) => LoginScreen(), // Login Screen
        '/otp': (context) => OtpVerificationScreen(mobileNumber: ModalRoute.of(context)?.settings.arguments as String), // OTP Verification Screen
        '/register': (context) => RegisterScreen(mobileNumber: ModalRoute.of(context)?.settings.arguments as String), // Registration Screen
        '/landing': (context) => LandingPage(), // Landing Page
      },
    );
  }
}
