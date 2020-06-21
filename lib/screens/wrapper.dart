import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplelearnnteacherss/screens/signInSignup.dart';
import 'package:simplelearnnteacherss/screens/teachserMain.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return user == null ? LoginSignUp() : TeachersMainPage();
  }
}