import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomMailLoginScreen extends StatefulWidget {
  @override
  _CustomMailLoginScreenState createState() => _CustomMailLoginScreenState();
}

class _CustomMailLoginScreenState extends State<CustomMailLoginScreen> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          'CREATE TABLE login_info(id INTEGER PRIMARY KEY, server TEXT, email TEXT, password TEXT)',
        );
      },
    );
  }

  Future<void> _saveLoginInfo() async {
    if (_database != null) {
      await _database!.insert(
        'login_info',
        {
          'server': _serverController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Mail Server Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serverController,
              decoration: InputDecoration(labelText: 'Mail Server'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveLoginInfo();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login info saved')),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}