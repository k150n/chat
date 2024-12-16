import 'package:flutter/material.dart';
import 'auth_page.dart';  // Страница авторизации

class UsersListPage extends StatelessWidget {
  final String email;
  final String name;
  final String uid;

  UsersListPage({
    required this.email,
    required this.name,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список пользователей'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: $email'),
            Text('Name: $name'),
            Text('UID: $uid'),
          ],
        ),
      ),
    );
  }
}
