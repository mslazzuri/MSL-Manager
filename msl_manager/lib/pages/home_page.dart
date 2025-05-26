import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msl_manager/services/auth_service.dart';
import 'package:msl_manager/themes/globals.dart';
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
            ),
            title: Text("Add New Service"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: serviceController,
                    decoration: InputDecoration(
                      hintText: 'Service (e.g. Netflix)',
                    ),
                    cursorColor: cursorColor,
                    style: Theme.of(context).textTheme.displaySmall
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email (e.g. email@example.com)',
                    ),
                    cursorColor: cursorColor,
                    style: Theme.of(context).textTheme.displaySmall
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username (e.g. user123)',
                    ),
                    cursorColor: cursorColor,
                    style: Theme.of(context).textTheme.displaySmall
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
                        onPressed: () {
                          setState(() {
                            addServiceObscureText = !addServiceObscureText;
                          });
                        },
                      ),
                    ),
                    cursorColor: cursorColor,
                    obscureText: addServiceObscureText,
                    style: Theme.of(context).textTheme.displaySmall
                  ),
                ],
              ),
            ),
            actions: [
              
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
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: Center(child: Text("Manage Service")),

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
              
              child: Text('Cancel', style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: primaryButtonTextColor,
                fontWeight: FontWeight.bold
              )
              ),
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
            ),
            title: Center(child: Text('Update')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    hintText: 'New Service Name',
                  ),
                  controller: newService,
                  style: Theme.of(context).textTheme.displaySmall
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    hintText: 'New Email',
                  ),
                  controller: newEmail,
                  style: Theme.of(context).textTheme.displaySmall
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    hintText: 'New Username',
                  ),
                  controller: newUsername,
                  style: Theme.of(context).textTheme.displaySmall
                ),
                const SizedBox(height: 10,),
                TextField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        updateServiceObscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          updateServiceObscureText = !updateServiceObscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: updateServiceObscureText,
                  controller: newPassword,
                  style: Theme.of(context).textTheme.displaySmall
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: Center(child: Text('Delete')),        

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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> filteredServices = [];
        return StatefulBuilder(
          builder: (context, setState) {
            void filterServices(String query) {
              setState(() {
                filteredServices = _services
                    .where((service) => service['service']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              title: Text('Search Service'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Type service name...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: filterServices,
                      autofocus: true,
                      style: Theme.of(context).textTheme.displaySmall,
                      cursorColor: cursorColor,
                    ),
                    const SizedBox(height: 16),
                    
                    filteredServices.isEmpty && searchController.text.isNotEmpty
                    ? Text('No matches found.', style: Theme.of(context).textTheme.displaySmall)
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: filteredServices.length,
                          itemBuilder: (context, index) {
                            final service = filteredServices[index];
                            return Card(
                              color: cardFillColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: avatarFillColor,
                                  child: Text(
                                    service['service'][0].toUpperCase(),
                                    style: TextStyle(
                                      color: avatarTextColor,
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
                                  Navigator.pop(context);
                                  _showServiceDialog(service);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showServiceDialog(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (_) {
        bool obscurePassword = true;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            title: Text(service['service']),
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
                        color: black,
                        tooltip: obscurePassword ? 'Show password' : 'Hide password',
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        color: black,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: background,
      
      appBar: CustomAppBar(title: "$_userName's wallet", 
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
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

              color: cardFillColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),

              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              
              child: ListTile(
              
                leading: CircleAvatar(
                  backgroundColor: avatarFillColor,
                  child: Text(
                    service['service'][0].toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: avatarTextColor,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              
                trailing: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: settingsIconColor
                  ),
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              
                onTap: () => _showServiceDialog(service),
              ),
            );

          },
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 70, 0),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: 'Add new service',

                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(6),
                ),

                textStyle: GoogleFonts.sourceCodePro(
                  color: lightGray,
                ),

                verticalOffset: 30,

                child: FloatingActionButton(
                  heroTag: 'add-service', 
                  onPressed: _showAddServiceDialog,
                  
                  backgroundColor: primaryButtonFillColor,
                  foregroundColor: neonGreen,
                  hoverColor: lightBackground,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: lightGray,
                      width: 2,
                    ),
                  ),
                  
                  child: Icon(Icons.add),
                ),
              ),
              
              const SizedBox(width: 10),
              
              Tooltip(
                
                message: "Generate password",

                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(6),
                ),

                textStyle: GoogleFonts.sourceCodePro(
                  color: lightGray,
                ),

                verticalOffset: 30,
                
                child: FloatingActionButton(
                  heroTag: 'generate-password',
                  onPressed: () => Navigator.pushNamed(context, '/password-generator'),
                
                  backgroundColor: primaryButtonFillColor,
                  foregroundColor: neonGreen,
                  hoverColor: lightBackground,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: lightGray,
                      width: 2,
                    ),
                  ),
                  
                  child: Icon(Icons.lock),
                ),
              ),
            ],
          ),
        ),
        


    );
  }
}
