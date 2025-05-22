import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';
import 'package:msl_manager/widgets/hover_scale_text.dart';

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

  Future<void> _deleteAccount() async {
    final TextEditingController confirmController = TextEditingController();
    bool confirmed = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Type 'DELETE' (all uppercase) to confirm account deletion. This action cannot be undone.",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(
                  hintText: "Type 'DELETE' here",
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (confirmController.text.trim() == 'DELETE') {
                      confirmed = true;
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (!confirmed) return;

    try {
      final user = await _authService.currentUser;
      final uid = user?.uid;
      if (uid == null || user == null) throw Exception('User not found.');

      // Delete user from Firestore 'users' and 'services' collections
      await _authService.deleteUserData(uid);

      // Delete user from Firebase Auth
      await user.delete();

      // Sign out and navigate to login
      await _authService.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('We are sad you\'re leaving. Hope to see you again soon!')),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
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
                  
                  const SizedBox(height: 10),
                  
                  Center(
                    child: TextButton.icon(
                      icon: Icon(Icons.delete, color: Colors.red[900],),
                      label: HoverScaleText(text: "Delete Account"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red[900],
                        backgroundColor: Colors.grey[50],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        overlayColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(width: 0, color: Colors.transparent),
                        ),
                      ),
                      onPressed: () => _deleteAccount(),
                    )
                  )
                ],
              ),
            ),
    );
  }
}