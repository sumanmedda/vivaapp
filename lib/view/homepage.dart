import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Welcome'),
          ),
          Center(
            child: Text(user.email!),
          ),
          ElevatedButton(
            onPressed: () {
              signOut();
            },
            child: const Text('SignOut'),
          ),
        ],
      ),
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
