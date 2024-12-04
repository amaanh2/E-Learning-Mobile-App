import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Tab'),
      ),
      body: const Center(child: Text('Profile Tab stuff here')),
    );
  }
}
