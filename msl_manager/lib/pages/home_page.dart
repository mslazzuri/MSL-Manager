import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String? _userName;
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadUserInfo();
  }

  Future<void> _loadServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final services = await _authService.getServicesList(user.uid);
      setState(() {
        _services = services;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    final String? name = await _authService.currentUserName;
    // final String? email = await _authService.currentUserEmail;
    // final String? phone = await _authService.currentUserPhone;

    setState(() {
      _userName = name;
      // userEmail = email;
      // userPhone = phone;
    });
  }

  Future<void> _showAddServiceDialog() async {
    final serviceController = TextEditingController();
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        
        title: Text('Add New Service', style: Theme.of(context).textTheme.headlineMedium),
        
        backgroundColor: Colors.grey[50],
        
        content: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: serviceController,
                decoration: InputDecoration(
                    hintText: 'Service (e.g. Netflix)',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),
              
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email (e.g. email@example.com)',
                  ),
                cursorColor: Colors.blueGrey[900],
              ),
              
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'Username (e.g. user123)',
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
            ],
          ),
        ),
        
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await _authService.addServiceToUser(
                  userId: user.uid,
                  serviceName: serviceController.text,
                  email: emailController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                );

                if(!context.mounted) return;
                
                Navigator.pop(context);
                
                _loadServices(); // Refresh list
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[50],
      
      appBar: CustomAppBar(title: "$_userName's wallet", 
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {}
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if(!context.mounted) return;
              
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _services.isEmpty
      ? const Center(child: Text('No services added yet.'))
      : ListView.builder(
          itemCount: _services.length,
          itemBuilder: (context, index) {
            final service = _services[index];
            
            return Card(

              color: Colors.grey[200],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Colors.blueGrey[900]!,
                  width: 1,
                ),
              ),

              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              
              child: ListTile(
              
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey[100],
                  child: Text(
                    service['service'][0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: service['service'],
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      TextSpan(
                        text: ' (${service['email']})',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              
                onTap: () {
                  // Navigate to a detail screen, show a dialog, or copy password, etc.

                  showDialog(
                    context: context,
                    builder: (_) {
                      bool obscurePassword = true;

                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          title: Text(service['service'], style: Theme.of(context).textTheme.headlineMedium),
                          backgroundColor: Colors.grey[50],
                          content: SizedBox(
                            width: 400,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${service['email']}', style: Theme.of(context).textTheme.displaySmall),
                                SizedBox(height: 8,),
                                Text('Username: ${service['username']}', style: Theme.of(context).textTheme.displaySmall),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Password: ${obscurePassword ? '•' * service['password'].length : service['password']}',
                                        style: Theme.of(context).textTheme.displaySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                                      tooltip: obscurePassword ? 'Show password' : 'Hide password',
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy),
                                      tooltip: 'Copy password',
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: service['password']));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Password copied to clipboard')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                },
              ),
            );

          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _showAddServiceDialog,
          
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.blueGrey[900],
          hoverColor: Colors.grey[300],
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: Colors.blueGrey[900]!,
              width: 1,
            ),

          ),
          
          child: Icon(Icons.add),
        ),
    );
  }
}
