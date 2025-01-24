import 'package:flutter/material.dart';

void main() {
  runApp(PortalApp());
}

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PortalScreen(),
    );
  }
}

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  void _navigateToLogin(BuildContext context, String provider) {
    // Navigate to the respective login screen
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $provider login')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Portal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToLogin(context, 'Gmail'),
              child: Text('Login with Gmail'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToLogin(context, 'Outlook'),
              child: Text('Login with Outlook'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToLogin(context, 'iCloud'),
              child: Text('Login with iCloud'),
            ),
          ],
        ),
      ),
    );
  }
}