import 'package:flutter/material.dart';
import 'package:mailchat/login-provider/custom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

class PortalScreen extends StatefulWidget {
  const PortalScreen({super.key});

  @override
  _PortalScreenState createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'login_info.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE login_info(id INTEGER PRIMARY KEY, server TEXT, email TEXT)',
        );
      },
    );
  }

  Future<bool> _hasServerInfo() async {
    final List<Map<String, dynamic>> maps = await _database!.query('login_info');
    return maps.isNotEmpty;
  }

  void _navigateToLogin(BuildContext context, String provider) async {
    if (await _hasServerInfo()) {
      _showServerExistsDialog(context, provider);
    } else {
      _proceedToLogin(context, provider);
    }
  }

  void _showServerExistsDialog(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Server Exists'),
          content: Text('A mail server is already configured. Do you want to delete it and proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteServerInfo();
                Navigator.of(context).pop();
                _proceedToLogin(context, provider);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteServerInfo() async {
    await _database!.delete('login_info');
  }

  void _proceedToLogin(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $provider login')),
    );
    // Add your login navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Portal'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _navigateToLogin(context, 'Gmail'),
              child: Text('Login with Gmail'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _navigateToLogin(context, 'Outlook'),
              child: Text('Login with Outlook'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _navigateToLogin(context, 'iCloud'),
              child: Text('Login with iCloud'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              ),
              onPressed: () async {
              if (await _hasServerInfo()) {
                _showServerExistsDialog(context, 'Custom Mail Server');
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomMailLoginScreen()),
                );
              }
              },
              child: Text('Login with Custom Mail Server'),
            ),
          ],
        ),
      ),
    );
  }
}