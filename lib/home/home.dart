import 'package:flutter/material.dart';
import 'package:issuetracker/issue/issue.dart';
import 'package:issuetracker/login/login.dart';
import 'package:issuetracker/profile/profile.dart';
import 'package:issuetracker/service/auth.dart';
import 'package:issuetracker/shared/error.dart';
import 'package:issuetracker/shared/loading.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const Issue();
        } else {
          // Handle null or missing data state
          return const Login();
        }
      },
    );
  }
}
