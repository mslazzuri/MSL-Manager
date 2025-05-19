import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:msl_manager/firebase_options.dart';
import 'package:msl_manager/pages/login_page.dart';
import 'package:msl_manager/themes/theme.dart'; 
import 'package:msl_manager/pages/home_page.dart';
import 'package:msl_manager/pages/register_page.dart'; 

Future <void> main() async {
  
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: appTheme,

      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
      }
    );
  }
}
