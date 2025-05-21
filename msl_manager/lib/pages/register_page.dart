import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/logo.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


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
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Check if any field is empty
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    // Check if email is valid
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    // Check the phone number format
    final phoneRegex = RegExp(r'^\+\d{10,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number with country code (e.g. +15551234567).')),
      );
      return;
    }
    
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

      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      confirmPasswordController.clear();
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
                  prefixIcon: Icon(
                    Icons.person_4,
                    color: Colors.blueGrey[900]!,
                  ),
                ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    hintText: 'Last Name',
                    prefixIcon: Icon(Icons.person_4_outlined, color: Colors.blueGrey[900]!,),
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blueGrey[900]!,),
                  ),
                cursorColor: Colors.blueGrey[900],
              ),

              const SizedBox(height: 10),
              IntlPhoneField(
                controller: phoneController,
                cursorColor: Colors.blueGrey[900],
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  // E.164 format
                },
              ),

              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.blueGrey[900]!,),
                  ),
                cursorColor: Colors.blueGrey[900],
                obscureText: true,
              ),

              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_rounded, color: Colors.blueGrey[900]!),
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
