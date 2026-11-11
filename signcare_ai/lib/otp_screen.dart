import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String password;
  final String name;
  final String age;
  final String gender;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final String simulatedOtp = "1234";

  void verifyOtp() async {
    if (otpController.text.trim() == simulatedOtp) {
      // 1. Local SharedPreferences mein save karein
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reg_phone_${widget.phone}', widget.phone);
      await prefs.setString('reg_pass_${widget.phone}', widget.password);
      await prefs.setString('reg_name_${widget.phone}', widget.name);
      await prefs.setString('reg_age_${widget.phone}', widget.age);
      await prefs.setString('reg_gender_${widget.phone}', widget.gender);

      // 2. Django Backend par saari details ke sath save karein
      await ApiService.savePreferences(
        widget.phone,
        widget.name,
        widget.age,
        widget.gender,
        widget.password,
        'English',
        'Light',
        'Default',
      );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Account registered successfully on server with all details!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid OTP'),
          content: const Text('Please enter the correct verification code (Hint: 1234)'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(title: const Text('OTP Verification'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Verification code sent to\n${widget.phone}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text('Enter 4-Digit OTP (Use: 1234)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOtp,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Verify & Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}