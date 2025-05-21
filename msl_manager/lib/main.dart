import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:msl_manager/firebase_options.dart';
import 'package:msl_manager/pages/login_page.dart';
import 'package:msl_manager/themes/theme.dart'; 
import 'package:msl_manager/pages/home_page.dart';
import 'package:msl_manager/pages/profile_page.dart';
import 'package:msl_manager/pages/register_page.dart'; 
import 'package:window_size/window_size.dart';
import 'dart:io';

Future <void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  // Set the window size for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('MSL Manager');
    setWindowMinSize(const Size(800, 600));
    setWindowMaxSize(const Size(4000, 1200));
    setWindowFrame(Rect.fromLTRB(0, 0, 800, 800));
  }  
  
  // Initialize Firebase
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
      theme: appTheme,

      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
      }
    );
  }
}
