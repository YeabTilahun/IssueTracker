import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:issuetracker/service/auth.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
}
