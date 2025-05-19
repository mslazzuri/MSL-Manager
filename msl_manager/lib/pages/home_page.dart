import 'package:flutter/material.dart';
import 'package:msl_manager/widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBar(title: "Home"),
      
      backgroundColor: Colors.blueGrey[800],

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to MSL Manager', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get Started'),
            ),
          ],
        ),
      )
    );
  }
}