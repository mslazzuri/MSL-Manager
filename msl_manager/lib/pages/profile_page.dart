import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:msl_manager/services/auth_service.dart';

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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
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
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(
                        _name != null && _name!.isNotEmpty ? _name![0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Name:', style: Theme.of(context).textTheme.headlineSmall),
                  Text(_name ?? '-', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text('Email:', style: Theme.of(context).textTheme.headlineSmall),
                  Text(_email ?? '-', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text('Phone:', style: Theme.of(context).textTheme.headlineSmall),
                  Text(_phone ?? '-', style: Theme.of(context).textTheme.displaySmall),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () async {
                        await _authService.signOut();
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}