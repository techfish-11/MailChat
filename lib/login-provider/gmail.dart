import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GmailLoginScreen extends StatefulWidget {
  @override
  _GmailLoginScreenState createState() => _GmailLoginScreenState();
}

class _GmailLoginScreenState extends State<GmailLoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
          'CREATE TABLE login_info(id INTEGER PRIMARY KEY, email TEXT, displayName TEXT)',
        );
      },
    );
  }

  Future<void> _loginWithGmail() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        await _saveLoginInfo(account);
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Logged in as ${account.displayName}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }

  Future<void> _saveLoginInfo(GoogleSignInAccount account) async {
    await _database?.insert(
      'login_info',
      {
        'email': account.email,
        'displayName': account.displayName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Gmail'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _loginWithGmail,
          child: Text('Login with Gmail'),
        ),
      ),
    );
  }
}