import 'package:issuetracker/home/home.dart';
import 'package:issuetracker/issue/issue.dart';
import 'package:issuetracker/login/login.dart';
import 'package:issuetracker/notification/notification.dart';
import 'package:issuetracker/profile/profile.dart';
import 'package:issuetracker/reportIssue/reportIssue.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/login': (context) => const Login(),
  '/issue': (context) => const Issue(),
  '/profile': (context) => const Profile(),
  '/reportIssue': (context) => const ReportIssue(),
  '/notification': (context) => const NotificationPage()
};
