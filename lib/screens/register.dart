import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp.dart'; // Import OTP verification screen
import 'landing.dart'; // Import the landing page

class RegisterScreen extends StatefulWidget {
  final String mobileNumber; // Pass mobile number from the previous screen
  RegisterScreen({required this.mobileNumber});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  bool _isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
    });

    // Prepare data for the API request
    final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral'); // Replace with your actual API URL
    final body = json.encode({
      'email': _emailController.text,
      'password': _passwordController.text,
      'referralCode': _referralController.text.isEmpty ? null : _referralController.text,
      'mobileNumber': widget.mobileNumber, // Include mobile number
    });

    try {
      // Make POST request to the API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // If registration is successful, navigate to the OTP screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(mobileNumber: widget.mobileNumber),
            ),
          );
        } else {
          // Handle any specific errors or messages from the API
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Registration failed: ${responseData['message']}'),
          ));
        }
      } else {
        // Error, handle it
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed: ${response.body}'),
        ));
      }
    } catch (error) {
      // Handle error during the request
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred: $error'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            // Logo or icon for DealsDray (placeholder for now)
            Image.asset(
              'assets/img.png', // Replace with your logo asset
              height: 100,
            ),
            SizedBox(height: 20),

            // Title
            Text(
              "Let's Begin!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Subtitle
            Text(
              'Please enter your credentials to proceed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),

            // Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Create Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Referral Code Input (Optional)
            TextField(
              controller: _referralController,
              decoration: InputDecoration(
                labelText: 'Referral Code (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Loading indicator and red arrow button for submission
            _isLoading
                ? CircularProgressIndicator()
                : Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Call the registerUser function to submit data
                  if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                    registerUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(mobileNumber: widget.mobileNumber,),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all the required fields'),
                    ));
                  }
                },
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
