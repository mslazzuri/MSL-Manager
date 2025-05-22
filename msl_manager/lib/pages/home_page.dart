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
      builder: (context) {
        bool addServiceObscureText = true;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.blueGrey[900]!, width: 1),
            ),
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          addServiceObscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        color: Colors.blueGrey[900],
                        onPressed: () {
                          setState(() {
                            addServiceObscureText = !addServiceObscureText;
                          });
                        },
                      ),
                    ),
                    cursorColor: Colors.blueGrey[900],
                    obscureText: addServiceObscureText,
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

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    _loadServices(); // Refresh list
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showManageDialog(int index, Map<String, dynamic> service) {
    final user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    // Check if we have an uid

    if (uid == null)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not signed in. Please log in first.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: BorderSide(color: Colors.blueGrey[900]!, width: 1)),
        title: Center(child: Text('Manage Service', style: Theme.of(context).textTheme.headlineMedium)),        
        backgroundColor: Colors.grey[50],

        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: ()=>_showUpdateDialog(index, uid, service),
              child: Text('Update'),
            ),
            
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: ()=>_showDeleteDialog(index, uid),
              child: Text('Delete'),
            ),
          ],
        ),

        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
        ]
      )
    );
  }

  void _showUpdateDialog(int index, String uid, Map<String, dynamic> service) {
    final TextEditingController newService = TextEditingController(text: service['service']);
    final TextEditingController newEmail = TextEditingController(text: service['email']);
    final TextEditingController newUsername = TextEditingController(text: service['username']);
    final TextEditingController newPassword = TextEditingController(text: service['password']);

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        bool updateServiceObscureText = true;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.blueGrey[900]!, width: 1),
            ),
            title: Center(child: Text('Update', style: Theme.of(context).textTheme.headlineMedium)),
            backgroundColor: Colors.grey[50],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Colors.blueGrey[900],
                  decoration: InputDecoration(
                    hintText: 'New Service Name',
                  ),
                  controller: newService,
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: Colors.blueGrey[900],
                  decoration: InputDecoration(
                    hintText: 'New Email',
                  ),
                  controller: newEmail,
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: Colors.blueGrey[900],
                  decoration: InputDecoration(
                    hintText: 'New Username',
                  ),
                  controller: newUsername,
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: Colors.blueGrey[900],
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        updateServiceObscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      color: Colors.blueGrey[900],
                      onPressed: () {
                        setState(() {
                          updateServiceObscureText = !updateServiceObscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: updateServiceObscureText,
                  controller: newPassword,
                ),
              ],
            ),
            actions: [
              Center(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _authService.udpateService(
                          index: index,
                          userId: uid,
                          newService: newService.text,
                          newEmail: newEmail.text,
                          newUsername: newUsername.text,
                          newPassword: newPassword.text,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context); // Close update dialog
                        _loadServices(); // Reload the updated list
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Service updated successfully!'))
                        );
                      },
                      child: Text("Update"),
                    ),
                    const SizedBox(width: 10,),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int index, String uid)
  {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: BorderSide(color: Colors.blueGrey[900]!, width: 1)),
        title: Center(child: Text('Delete', style: Theme.of(context).textTheme.headlineMedium)),        
        backgroundColor: Colors.grey[50],

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Text(
              "Are you sure you want to delete this service? This action is permanent.",
              style: Theme.of(context).textTheme.displaySmall
            ),
            
            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _authService.deleteService(userId: uid, index: index);

                    if (!context.mounted) return;

                    Navigator.pop(context); // Close update dialog

                    _loadServices(); // Reload the updated list

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Service deleted successfully!'))
                    );
                  },
                  child: Text("Confirm")
                ),

                const SizedBox(width: 10,),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            )
          ],
        ),
      )
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
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
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
      ? Center(child: Text('No services added yet.', style: Theme.of(context).textTheme.displaySmall))
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
              
                trailing: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed:() => _showManageDialog(index, service),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: BorderSide(color: Colors.blueGrey[900]!, width: 1)),
                          title: Text(service['service'], style: Theme.of(context).textTheme.headlineMedium),
                          backgroundColor: Colors.grey[50],
                          content: SizedBox(
                            width: 600,
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
