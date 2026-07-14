import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Added Firebase import
import '../../constants/app_images.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 2. Add Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 3. Helper function to handle the login process
  void loginUser() async {
    // Show a simple loading indicator while verifying with Firebase
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Close the loading dialog if successful
      if (mounted) Navigator.pop(context);

      // Navigate straight to your existing Home Screen route
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
      }
    } catch (e) {
      // Close the loading dialog if an error occurs
      if (mounted) Navigator.pop(context);

      // Show the error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                width: 170,
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                icon: Icons.lock,
                obscure: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                title: "Login",
                onPressed: loginUser, // 4. Pointed to the new login function
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.register,
                  );
                },
                child: const Text(
                  "Create Account",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}