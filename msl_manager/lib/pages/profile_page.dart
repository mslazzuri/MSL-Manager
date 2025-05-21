import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  String? _name;
  String? _email;
  String? _phone;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = await _authService.currentUserName;
    final email = await _authService.currentUserEmail;
    final phone = await _authService.currentUserPhone;
    setState(() {
      _name = name;
      _email = email;
      _phone = phone;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (!context.mounted) return;
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                    Center(
                    child: Column(
                      children: [
                      Container(
                        decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueGrey[900]!,
                          width: 2,
                        ),
                        ),
                        child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueGrey[100],
                        child: Text(
                          _name != null && _name!.isNotEmpty ? _name![0].toUpperCase() : '?',
                          style: TextStyle(
                          fontSize: 36,
                          color: Colors.blueGrey[900]!,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(_name ?? '-', style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                    ),

                  

                  const SizedBox(height: 16),
                  Text('Email:', style: Theme.of(context).textTheme.headlineSmall),
                  Text(_email ?? '-', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text('Phone:', style: Theme.of(context).textTheme.headlineSmall),
                  Text(_phone ?? '-', style: Theme.of(context).textTheme.displaySmall),
                  Spacer(),
                  
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.password, color: Colors.white,),
                      label: const Text('Change Password'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () async {

                        final TextEditingController emailController = TextEditingController();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(child: Text('Update Password')),
                              content: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    Text(
                                      'Enter your email. We will send you a link to update your password.',
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                      ),
                                      cursorColor: Colors.blueGrey[900],
                                    ),
                                  ],
                                )
                              ),

                              actions: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      const SizedBox(width: 20),

                                      ElevatedButton(
                                        onPressed: () async {
                                          await _authService.resetPassword(emailController.text.trim());
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Send link'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}