import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tired/controllers/auth%20controller.dart';
import 'package:tired/views/widgets/screens/add%20video%20screen.dart';
import 'package:tired/views/widgets/screens/chat%20page.dart';
import 'package:tired/views/widgets/screens/profile%20screen.dart';
import 'package:tired/views/widgets/screens/search%20screen.dart';
import 'package:tired/views/widgets/screens/video%20screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  ChatPage(
      receiverUserUd: firebaseAuth.currentUser!.uid,
      receiverUserEmail: firebaseAuth.currentUser!.uid),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;

bool showProgressbar = false;
