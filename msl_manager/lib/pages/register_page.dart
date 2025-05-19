import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/logo.dart';
import 'package:msl_manager/services/auth_service.dart';

class RegisterPage extends StatefulWidget
{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
{
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final AuthService authService = AuthService();

  void _handleRegister() async
  {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;

    try {
      await authService.register(firstName, lastName, phone, email, password);

      if(!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful! Welcome, $firstName!'),
        ),
      );
      
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('Registration failed: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please check your credentials.'),
        ),
      );

      emailController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Logo(),
              const SizedBox(height: 20),

              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    hintText: 'First Name',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    hintText: 'Last Name',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                cursorColor: Colors.blueGrey[900],
                obscureText: true,
              ),

              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                cursorColor: Colors.blueGrey[900],
                obscureText: true,
              ),

              const SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  ElevatedButton(
                    onPressed: _handleRegister,
                    child: const Text('Register'),
                  ),
                  
                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Back to Login'),
                  ),
                ],
              )
            ],
          )
        ),
      )
    );
  }
  
}
