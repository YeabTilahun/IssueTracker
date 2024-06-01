import 'package:flutter/material.dart';
import 'package:issuetracker/service/auth.dart';

class Issue extends StatefulWidget {
  const Issue({super.key});

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: const Text('logout'),
        onPressed: () async {
          await AuthService().signout();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
      ),
    ));
  }
}
