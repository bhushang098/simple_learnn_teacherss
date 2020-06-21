import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:simplelearnnteacherss/services/authentication.dart';
import 'package:simplelearnnteacherss/services/dbCollectinService.dart';

class TeachersMainPage extends StatefulWidget {
  @override
  _TeachersMainPageState createState() => _TeachersMainPageState();
}

class _TeachersMainPageState extends State<TeachersMainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Auth _auth;
  String courseList;
  DbTeachersCollection db;
  String coursesSold;
  String balance;
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    _auth = new Auth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    saaignbalance();

    return Scaffold(
      backgroundColor: Colors.teal[50],
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Balance : ${balance} Rs',
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () async {
                    db = new DbTeachersCollection(user.uid);
                    db.getCourseList(user.uid).then((onValue) {
                      courseList = onValue;
                      Navigator.pop(context);
                      navToMyCourses(courseList);
                    });
                    print('want to see courses');
                  },
                  child: ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text(
                      'Your Courses',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    db = new DbTeachersCollection(user.uid);
                    db.getCoursesSold(user.uid).then((onValue) {
                      coursesSold = onValue;
                    });
                    print('see courses sold ');
                    navToCoursesSold(coursesSold);
                  },
                  child: ListTile(
                    leading: Icon(Icons.subscriptions),
                    title: Text(
                      'course soled Since \n Last Redeem',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    // reeden request
                    db = new DbTeachersCollection(user.uid);
                    db.getbalance(user.uid).then((onValue) {
                      int bal = num.parse(onValue);
                      if (bal >= 100)
                        navToreedem(bal);
                      else
                        Fluttertoast.showToast(
                            msg: 'Balance is very low Can not make Request');
                    });
                  },
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(
                      'Reeadem Request',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    print('terms and conditions');
                    navToTerms();
                  },
                  child: ListTile(
                    leading: Icon(Icons.note),
                    title: Text(
                      'Terms And Conditions',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () async {
                    print('Log out user ');
                    await _auth.signOut();
                    navToLogin();
                  },
                  child: ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      'Log Out',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Simple Learn'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
//                if (user.isEmailVerified) {
//                  navToGetCourseDetails();
//                } else {
//                  //showAlertBox(context);
//                }
                navToGetCourseDetails();
                print('Print tapped Course Create');
              },
              child: Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: new AssetImage('images/courseIamhe.png'),
                        height: 90,
                        width: 90,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Create New Course',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal[800],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                navToShowTutorial();
                print('show tutorial');
              },
              child: Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                        image: new AssetImage('images/courseIamhe.png'),
                        height: 90,
                        width: 90,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'How to create course ?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal[800],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navToGetCourseDetails() {
    Navigator.pushNamed(context, '/GetGourseDetails');
  }

  void navToShowTutorial() {
    Navigator.pushNamed(context, '/TutorialScreen');
  }

  void navToMyCourses(String courseList) {
    Navigator.pushNamed(context, '/myCourses', arguments: courseList);
  }

  void showAlertBox(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Verify Email"),
      onPressed: () {
        Navigator.pop(context);
        _auth.sendEmailVerification().then((onValue) {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 8,
              msg: 'Verification Sent To Your Email Check Your InBox',
              backgroundColor: Colors.black54,
              textColor: Colors.white);
        });
        _auth.signOut();
        //navToHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email Not Verified"),
      content: Text("Before Creating any course Please verify Your Email"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void navToCoursesSold(String coursesSold) {
    Navigator.pushNamed(context, '/coursesSold', arguments: coursesSold);
  }

  void navToreedem(int balance) {
    Navigator.pushNamed(context, '/ReedenPage', arguments: balance);
  }

  navToTerms() {
    Navigator.pushNamed(context, '/TermsPage');
  }

  void saaignbalance() async {
    db = new DbTeachersCollection(user.uid);
    db.getbalance(user.uid).then((onValue) {
      balance = onValue;
    });
  }

  void navToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/LoginSignUp', (Route<dynamic> route) => false);
  }
}
