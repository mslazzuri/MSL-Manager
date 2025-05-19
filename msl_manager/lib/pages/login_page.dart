import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/logo.dart';
import 'package:msl_manager/services/auth_service.dart';

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void _handleLogin() async
  {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      await authService.signIn(email, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Login failed: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );

      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double breakpoint = 500;
    // final double screenHeight = screenSize.height;

    final EdgeInsets inputFieldPadding = screenWidth > breakpoint
      ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
      : const EdgeInsets.fromLTRB(0, 0, 0, 0);

    return Scaffold(
      
      backgroundColor: Colors.grey[50],
      
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Logo(),
              
              const SizedBox(height: 50),
              
              Padding(
                padding: inputFieldPadding,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  cursorColor: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: inputFieldPadding,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  cursorColor: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 20),
        
              screenWidth > breakpoint?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
        
                  const SizedBox(width: 20),
                  
                  ElevatedButton(
                    onPressed: () {
                      // Handle register logic here
                    },
                    child: const Text('Register'),
                  ),
                ]
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    child: const Text('Login'),
                  ),
        
                  const SizedBox(height: 20),
                  
                  ElevatedButton(
                    onPressed: () {
                      // Handle register logic here
                    },
                    child: const Text('Register'),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}