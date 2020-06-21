import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GetGourseDetails extends StatefulWidget {
  @override
  _GetGourseDetailsState createState() => _GetGourseDetailsState();
}

class _GetGourseDetailsState extends State<GetGourseDetails> {
  final autherName = TextEditingController();
  final price = TextEditingController();
  final courseName = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Course'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Course Name',
                ),
                controller: courseName,
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Author Name',
                ),
                controller: autherName,
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price of Course',
                ),
                keyboardType: TextInputType.number,
                controller: price,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                color: Colors.teal,
                onPressed: () async {
                  String scourseName, sAutherName, sprice;
                  scourseName = courseName.text;
                  sAutherName = autherName.text;
                  sprice = price.text;
                  if (scourseName.isEmpty ||
                      sprice.isEmpty ||
                      sAutherName.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the that user has entered by using the
                          // TextEditingController.
                          content: Text('provide all info'),
                        );
                      },
                    );
                  } else {
                    navToUploadFreeVid(
                        new ScreenArgs(user, scourseName, sAutherName, sprice));
                  }
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navToUploadFreeVid(ScreenArgs screenArgs) {
    Navigator.pushNamed(context, '/UploadFreeVid', arguments: screenArgs);
  }
}

class ScreenArgs {
  FirebaseUser _user;
  String _courseName, _authorName, _price;

  ScreenArgs(this._user, this._courseName, this._authorName, this._price);

  get price => _price;

  set price(value) {
    _price = value;
  }

  get authorName => _authorName;

  set authorName(value) {
    _authorName = value;
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  FirebaseUser get user => _user;

  set user(FirebaseUser value) {
    _user = value;
  }
}
