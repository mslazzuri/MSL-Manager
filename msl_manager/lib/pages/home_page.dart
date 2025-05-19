import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, redirect to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    final userEmail = user?.email ?? "Unknown User";
    
    return Scaffold(
      
      appBar: CustomAppBar(title: "Home"),
      
      backgroundColor: Colors.blueGrey[800],

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as $userEmail', style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
      )
    );
  }
}