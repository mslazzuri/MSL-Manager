import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/logo.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:msl_manager/widgets/hover_scale_text.dart';
import 'package:msl_manager/themes/globals.dart' as globals;

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
  bool _obscureText = true; // True by default

  void _togglePasswordVisibility()
  {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
    final double breakpoint = 600;
    // final double screenHeight = screenSize.height;

    final EdgeInsets inputFieldPadding = screenWidth > breakpoint
      ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
      : const EdgeInsets.fromLTRB(0, 0, 0, 0);

    return Scaffold(
      
      backgroundColor: globals.backgroundColor,
      
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
                  cursorColor: globals.cursorColor,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: inputFieldPadding,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: globals.textDark,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscureText,
                  cursorColor: globals.neonGreen,
                  onSubmitted: (_) => _handleLogin(),
                  style: Theme.of(context).textTheme.displaySmall,
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
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text('New user? Register'),
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
                  
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text('New user? Register'),
                  ),
                ]
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your email to reset password.')),
                    );
                    return;
                  }
                  try {
                    await authService.resetPassword(email);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset email sent! Check your inbox.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send reset email.')),
                    );
                  }
                },
                
                style: TextButton.styleFrom(
                  backgroundColor: globals.backgroundColor,
                  elevation: 0,
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  fixedSize: const Size(250, 50),
                  overlayColor: globals.backgroundColor,
                ),
                child: HoverScaleText(
                  text: 'Forgot Password?',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: globals.neonGreen,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}