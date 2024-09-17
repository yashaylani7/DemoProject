import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
import 'landing.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber; // The mobile number to show in the text
  OtpVerificationScreen({required this.mobileNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  Timer? _timer;
  int _start = 120; // Countdown start (2 minutes)

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Timer for OTP expiration
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Send Again (resend OTP)
  void resendOtp() async {
    setState(() {
      _start = 120;
    });
    startTimer();

    // API call to resend OTP
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp/resend'; // Replace with actual API URL
    final Map<String, String> data = {
      "mobileNumber": widget.mobileNumber,
      "deviceId": "66863b1b5120b12d7e1820ee", // Example device ID
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Resend OTP Response status: ${response.statusCode}');
      print('Resend OTP Response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent again!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP. Please try again.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  // Verify OTP
  void verifyOtp() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    print('Entered OTP: $otp'); // Debug OTP input

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    // API call to verify OTP
    final String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp/verify'; // Replace with actual API URL
    final Map<String, String> data = {
      "mobileNumber": widget.mobileNumber,
      "otp": otp,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print('Verify OTP Response status: ${response.statusCode}');
      print('Verify OTP Response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Parsed JSON: $jsonResponse'); // Debug JSON response

        if (jsonResponse['status'] == 'success') {
          // Navigate to the landing page for existing users or registration page for new users
          if (jsonResponse['isExistingUser'] == true) {
            print('Navigating to LandingPage'); // Debug navigation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            );
          } else {
            print('Navigating to RegisterScreen'); // Debug navigation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(mobileNumber: widget.mobileNumber),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP. Please try again.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  // Format the timer in MM:SS
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
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
            // Icon image for OTP verification (Replace with your asset)
            Image.asset(
              'assets/img_1.png', // Path to your icon asset
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),

            // OTP Verification Title
            Text(
              'OTP Verification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Mobile number text
            Text(
              'We have sent a unique OTP number to your mobile +91-${widget.mobileNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus(); // Move focus to the next field
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 30),

            // Countdown timer and "Send Again" button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatTime(_start),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: _start == 0 ? resendOtp : null, // Disable until timer finishes
                  child: Text(
                    'SEND AGAIN',
                    style: TextStyle(
                      color: _start == 0 ? Colors.redAccent : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Verify OTP Button
            ElevatedButton(
              onPressed: verifyOtp,
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                minimumSize: Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "VERIFY OTP",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
