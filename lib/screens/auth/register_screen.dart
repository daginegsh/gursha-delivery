import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added Firebase import
import '../../constants/app_images.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

// Changed to StatefulWidget so we can handle input controllers
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Input controllers to capture what the user types
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to register the user in Firebase
  void registerUser() async {
    // Show a loading indicator while creating the account
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Create user in your Firebase Console
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Close the loading dialog if successful
      if (mounted) Navigator.pop(context);

      // Show a green success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account Created Successfully! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Send the user back to the login screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      // Close the loading dialog if an error happens
      if (mounted) Navigator.pop(context);

      // Show the error message (e.g., "email already in use")
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Failed: ${e.toString()}'),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
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
                  title: "Sign Up",
                  onPressed: registerUser, // Calls the Firebase registration function
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}