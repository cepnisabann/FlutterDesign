// ignore_for_file: prefer_const_constructors

import 'package:design/base/base_widget.dart';
import 'package:design/pages/viewmodels/profilepage_vm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePageViewModel, ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title: const Text("Profil"),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                    MaterialStateProperty.all(Colors.orange.shade800)),
            onPressed: () async {
              viewModel
                  .signOut()
                  .then((value) => Navigator.pushNamed(context, '/login'));
            },
            child: const Text('Sign out',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: viewModel.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching user data'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Profil'),
                  Text('User Email: ${user.email}'),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No user data available'),
            );
          }
        },
      ),
    );
  }
}
