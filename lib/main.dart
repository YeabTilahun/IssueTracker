import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:issuetracker/home/home.dart';
import 'package:issuetracker/issue/issue.dart';
import 'package:issuetracker/login/login.dart';
import 'package:issuetracker/profile/profile.dart';
import 'package:issuetracker/reportIssue/reportIssue.dart';
import 'package:issuetracker/routes.dart';
import 'package:issuetracker/service/firestore.dart';
import 'package:issuetracker/shared/error.dart';
import 'package:issuetracker/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:issuetracker/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Center(
          child: Text('Error occurred.'),
        );
      } else if (snapshot.hasData && snapshot.data != null) {
        // User is authenticated
        return MaterialApp(
          debugShowCheckedModeBanner: true, // Make it false later
          routes: appRoutes,
        );
      } else {
        // User is not authenticated, show login screen
        return const MaterialApp(
          debugShowCheckedModeBanner: true, // Make it false later
          home: Login(),
        );
      }
    },
  ));
}
