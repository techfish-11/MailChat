import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; // Change to sqflite package
import '/chat/chat_screen.dart'; // Import the ChatScreen
import 'login-provider/portal.dart'; // Import the PortalScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MailChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactsScreen(),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  late Database database;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'contacts_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, status TEXT, email TEXT)',
        );
      },
      version: 1,
    );
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final List<Map<String, dynamic>> maps = await database.query('contacts');
    setState(() {
      contacts = List.generate(maps.length, (i) {
        return Contact(
          id: maps[i]['id'],
          name: maps[i]['name'],
          status: maps[i]['status'],
          email: maps[i]['email'],
        );
      });
    });
  }

  Future<void> _addContact(String name, String status, String email) async {
    await database.insert(
      'contacts',
      {'name': name, 'status': status, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _loadContacts();
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final email = emailController.text;
                _addContact(name, 'Offline', email);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPortal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PortalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () => _navigateToPortal(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(contacts[index].name[0]),
            ),
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].status),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    contactName: contacts[index].name,
                    contactEmail: contacts[index].email,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

class Contact {
  final int id;
  final String name;
  final String status;
  final String email;

  Contact({required this.id, required this.name, required this.status, required this.email});
}