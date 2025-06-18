import 'package:flutter/material.dart';
import '../auth_service.dart'; // путь зависит от расположения auth_service.dart
import 'home_page.dart';


class LoginPage extends StatelessWidget {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login, color: Colors.white,),
          label: Text('Sing in with Google'),
          onPressed: () async {
            final user = await authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                );
            }
          },
        ),
      ),
    );
  }
}
