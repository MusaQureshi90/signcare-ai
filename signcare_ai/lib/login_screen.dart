import 'package:flutter/material.dart';
import 'main.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true; // Default true taake session expire na ho
  bool _obscurePassword = true;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    final numericRegExp = RegExp(r'^[0-9]+$');

    if (phone.length != 11 || !numericRegExp.hasMatch(phone) || !phone.startsWith('03')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Number'),
          content: const Text('Please enter a valid 11-digit numeric phone number (e.g., 03001234567).'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? savedPass = prefs.getString('reg_pass_$phone');
    String? savedName = prefs.getString('reg_name_$phone');

    if (savedPass == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Not Found'),
          content: const Text('This phone number is not registered. Please register first.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
              child: const Text('Register Now'),
            ),
          ],
        ),
      );
      return;
    }

    if (savedPass != password) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incorrect Password'),
          content: const Text('The password you entered is incorrect. Please try again.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      return;
    }

    // Hamesha session save ho ga
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_phone', phone);
    await prefs.setString('logged_name', savedName ?? 'User');

    if (!mounted) return;
    String savedLang = prefs.getString('app_language') ?? 'English';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userName: savedName ?? 'User',
          currentLang: savedLang,
          onLocaleChange: (locale, langName) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.medical_services, size: 60, color: Colors.teal),
                  const SizedBox(height: 10),
                  const Text('SignCare AI', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal)),
                  const Text('Login to Continue', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 25),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g. 03001234567',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                      child: const Text('Forgot Password?', style: TextStyle(color: Colors.teal)),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(value: rememberMe, onChanged: (val) => setState(() => rememberMe = val!)),
                      const Text('Remember me'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text('New here? Register now.', style: TextStyle(color: Colors.teal)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}