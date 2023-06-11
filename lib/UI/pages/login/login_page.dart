import 'package:flutter/material.dart';
import 'package:google_mao/UI/providers/current_position.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Login'),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.abc_sharp),
        onPressed: () async => CurrentPosition.goToMap(context),
      ),
    );
  }
}
