import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SendEmail {
  late Database _database;

  Future<void> initDatabase() async {
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

  Future<Map<String, String>> getLoginInfo() async {
    final List<Map<String, dynamic>> maps = await _database.query('login_info');
    if (maps.isNotEmpty) {
      return {
        'server': maps[0]['server'],
        'email': maps[0]['email'],
        'password': maps[0]['password'],
      };
    } else {
      throw Exception('No login information found');
    }
  }

  Future<void> sendEmail(String recipient, String subject, String body) async {
    await initDatabase();
    final loginInfo = await getLoginInfo();

    final smtpServer = SmtpServer(
      loginInfo['server']!,
      username: loginInfo['email'],
      password: loginInfo['password'],
    );

    final message = Message()
      ..from = Address(loginInfo['email']!, 'Your Name')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
}