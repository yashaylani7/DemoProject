import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectsub/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _sendDeviceData();
    Timer(Duration(seconds: 3), () {
      // Navigate to the login screen after 3 seconds
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  // Function to send device data
  Future<void> _sendDeviceData() async {
    final String apiUrl = "http://devapiv4.dealsdray.com/api/v2/user/device/add"; // Replace with the actual API URL

    // Create the device data payload
    Map<String, dynamic> deviceData = {
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(deviceData),
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('Data sent successfully: ${response.body}');
      } else {
        // Error occurred
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Error sending data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, // Background color of splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DealsDray Logo and Background
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background pattern image
                  Positioned(
                    child: Image.asset(
                      'assets/img_8.png', // Path to the pattern image
                      fit: BoxFit.cover,
                    ),
                  ),
                  // DealsDray logo at the center
                  Image.asset(
                    'assets/img.png', // Path to the logo image
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
            // Optional loading indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
