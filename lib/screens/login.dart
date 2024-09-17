import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp.dart'; // Ensure this path is correct
import 'register.dart'; // Import the registration screen
import 'landing.dart'; // Import landing page for existing users

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhoneSelected = true;
  TextEditingController _phoneController = TextEditingController();
  String deviceId = "66863b1b5120b12d7e1820ee"; // Example device ID

  Future<void> sendCode() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your ${isPhoneSelected ? 'phone number' : 'email'}'),
        ),
      );
      return;
    }

    final Map<String, String> data = {
      "mobileNumber": isPhoneSelected ? _phoneController.text : "",
      "email": !isPhoneSelected ? _phoneController.text : "",
      "deviceId": deviceId,
    };

    const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp'; // Replace with actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'existing') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(mobileNumber: _phoneController.text),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(mobileNumber: _phoneController.text),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send code. Please try again.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // DealsDray logo
            Center(
              child: Image.asset(
                'assets/img.png', // DealsDray logo
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            // Toggle for phone or email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPhoneSelected = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isPhoneSelected ? Colors.redAccent : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Phone", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPhoneSelected = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: !isPhoneSelected ? Colors.redAccent : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Email", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Glad to see you!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Please provide your ${isPhoneSelected ? 'phone number' : 'email'}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: isPhoneSelected ? 'Phone' : 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendCode,
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("SEND CODE", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
