import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplelearnnteacherss/screens/Registration.dart';
import 'package:simplelearnnteacherss/screens/addInCourse.dart';
import 'package:simplelearnnteacherss/screens/coursesSold.dart';
import 'package:simplelearnnteacherss/screens/myCourseDetails.dart';
import 'package:simplelearnnteacherss/screens/myCourses.dart';
import 'package:simplelearnnteacherss/screens/reedemrequest.dart';
import 'package:simplelearnnteacherss/screens/signInSignup.dart';
import 'package:simplelearnnteacherss/screens/teachserMain.dart';
import 'package:simplelearnnteacherss/screens/termsAndCondition.dart';
import 'package:simplelearnnteacherss/screens/tutorialScreen.dart';
import 'package:simplelearnnteacherss/screens/uploadFreeVideos.dart';
import 'package:simplelearnnteacherss/screens/uploadpaidVideos.dart';
import 'package:simplelearnnteacherss/screens/wrapper.dart';
import 'package:simplelearnnteacherss/services/authentication.dart';
import 'screens/getCourseDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: new Auth().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/LoginSignUp': (BuildContext context) => new LoginSignUp(),
          '/Registration': (BuildContext context) => new Registration(),
          '/TeachersMain': (BuildContext context) => new TeachersMainPage(),
          '/wrapper': (BuildContext context) => new Wrapper(),
          '/GetGourseDetails': (BuildContext context) => new GetGourseDetails(),
          '/UploadPaidVid': (BuildContext context) => new UploadPaidVid(),
          '/UploadFreeVid': (BuildContext context) => new UploadFreeVideos(),
          '/TutorialScreen': (BuildContext context) => new TutorialScreen(),
          '/myCourses': (BuildContext context) => new MyCourses(),
          '/myCourseDetails': (BuildContext context) => new MyCourseDetails(),
          '/coursesSold': (BuildContext context) => new CoursesSold(),
          '/ReedenPage': (BuildContext context) => new ReedemRequest(),
          '/TermsPage': (BuildContext context) => new TermsCondition(),
          '/AddInCourse': (BuildContext context) => new AddInCourse(),
        },
        home: Wrapper(),
      ),
    );
  }

//  void commitTofireStore(String courseName, FirebaseUser user) async {
//    final StorageReference firebaseStorageRef =
//        FirebaseStorage.instance.ref().child(courseName + '>>' + 'user1');
//
//    for (int i = 0; i < fileNames.length; i++) {
//      var fileName =
//          await firebaseStorageRef.child(fileNames[i]).getDownloadURL();
//
//      print('>>>>>>>>>>&*&()&()&(*&(&>>>>>>>>>' + fileName);
//    }
//
//    // Get all deta of bucket and call set Dopcument method for each video in bucket
////    final CollectionReference course = Firestore.instance.collection(courseName);
////    course.document()
//  }
}
