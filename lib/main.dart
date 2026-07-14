import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Make sure these import paths match your actual project folders!
import 'splash_screen.dart'; 
import 'login_screen.dart';
import 'register_screen.dart';
import 'routes/app_routes.dart'; // Handles your routing keys

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Fires up your Firebase connection
  runApp(const GurshaDelivery());
}

class GurshaDelivery extends StatelessWidget {
  const GurshaDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gursha Delivery',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // 1. Start the app on your orange loading screen
      home: const SplashScreen(), 

      // 2. Define your app routes so Navigator knows where to jump
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}

// --- Home Screen View (Linked to your Cloud Firestore 'foods' collection) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gursha Menu',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFC107),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Quick logout option for easy testing
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.brown),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No food items available yet.\nAdd some inside your Firebase Console!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
            );
          }

          final foodDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foodDocs.length,
            itemBuilder: (context, index) {
              final food = foodDocs[index].data() as Map<String, dynamic>;
              
              final String name = food['name'] ?? 'Unknown Item';
              final String price = food['price']?.toString() ?? '0';
              final String description = food['description'] ?? 'No description provided.';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFC107),
                    radius: 25,
                    child: Icon(Icons.fastfood, color: Colors.brown),
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  trailing: Text(
                    '$price ETB',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}