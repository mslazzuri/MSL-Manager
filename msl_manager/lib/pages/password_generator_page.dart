import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msl_manager/services/password_generator.dart';
import 'package:msl_manager/themes/globals.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => PasswordGeneratorPageState();
}

class PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  final PasswordGenerator _passwordGenerator = PasswordGenerator();
  late TextEditingController _passwordController;
  bool _includeSpecialChars = false;
  bool _includeNumbers = false;
  int _passwordLength = 12;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _generatePassword();
  }

  void _generatePassword() {
    final password = _passwordGenerator.generatePassword(
      length: _passwordLength,
      includeSpecialChars: _includeSpecialChars,
      includeNumbers: _includeNumbers,
    );
    _passwordController.text = password;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Password Generator',
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Special Characters Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Include special characters (!@#\$%^&* etc.):',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  Switch(
                    value: _includeSpecialChars,
                    onChanged: (val) {
                      setState(() {
                        _includeSpecialChars = val;
                        _generatePassword();
                      });
                    },
                    activeColor: neonGreen,
                    inactiveThumbColor: neonGreen,
                    inactiveTrackColor: black,
                  ),
                ],
              ),
              // Numbers Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Include numbers (0-9):',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: textLight),
                  ),
                  const Spacer(),
                  Switch(
                    value: _includeNumbers,
                    onChanged: (val) {
                      setState(() {
                        _includeNumbers = val;
                        _generatePassword();
                      });
                    },
                    activeColor: neonGreen,
                    inactiveThumbColor: neonGreen,
                    inactiveTrackColor: black,
                  ),
                ],
              ),
              // Password Length Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Password length:',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: textLight),
                  ),
                  Expanded(
                    child: Slider(
                      value: _passwordLength.toDouble(),
                      min: 8,
                      max: 40,
                      label: _passwordLength.toString(),
                      onChanged: (val) {
                        setState(() {
                          _passwordLength = val.round();
                          _generatePassword();
                        });
                      },
                      activeColor: neonGreen,
                      inactiveColor: black,
                    ),
                  ),
                  Text(
                    '$_passwordLength',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: textLight),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Editable Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Generated Password',
                  fillColor: inputTextFillColor,
                  labelStyle: Theme.of(context).textTheme.displaySmall?.copyWith(color: textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    color: lightBackground,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _passwordController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password copied to clipboard!')),
                      );
                    },
                  ),
                ),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: textLight),
                cursorColor: neonGreen,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _generatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonFillColor,
                  foregroundColor: primaryButtonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Generate New Password', style: Theme.of(context).textTheme.displaySmall
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}