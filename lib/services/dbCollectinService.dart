import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbTeachersCollection {
  final String uid;

  DbTeachersCollection(this.uid);

  final CollectionReference users = Firestore.instance.collection('teachers');

  Future pushTeachersData(String email, String mobNo, String coursesMade,
      String coursesSold, String balance) async {
    return await users.document(uid).setData({
      'email': email,
      'mobile_no': mobNo,
      'courses_made': coursesMade,
      'courses_sold': coursesSold,
      'balance': balance,
    });
  }

  Future<String> getCourseList(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('teachers').document(uid).get();
    return snapshot['courses_made'];
  }

  Future deletecoursesSold(String uid) async {
//    DocumentSnapshot teacherSnapShot =
//    await Firestore.instance.collection('teachers').document(uid).get();
//    var coursesSoldTill = teacherSnapShot['courses_sold'];
    return await users.document(uid).updateData({'courses_sold': '0'});
  }

  Future<String> getCoursesSold(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('teachers').document(uid).get();
    return snapshot['courses_sold'];
  }

  Future<String> getbalance(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('teachers').document(uid).get();
    return snapshot['balance'];
  }
}

class DbCoursesCollection {
  final String courseName;
  final FirebaseUser user;
  HashMap<String, String> lectures;
  final databaseReference = Firestore.instance;
  String AutherName;
  String price;

  DbCoursesCollection(
      this.courseName, this.user, this.lectures, this.AutherName, this.price);

  CollectionReference get course =>
      Firestore.instance.collection(courseName + '>>' + user.uid);

  CollectionReference get freeCourse => Firestore.instance.collection('videos');
  CollectionReference get paidCourse =>
      Firestore.instance.collection('paid_videos');
  CollectionReference get teachersCollection =>
      Firestore.instance.collection('teachers');

  Future pushpaidVideosData() async {
    int i = 0;
    for (var fileName in lectures.keys) {
      uploadPaidCoursedata(fileName, lectures[fileName]);
      if (i == 4) {
        break;
      }
      i++;
    }
  }

  Future pushFreeeVideosData() async {
    for (var fileName in lectures.keys) {
      uploadfreeCourseData(fileName, lectures[fileName]);
    }
  }

  PushLectureDeta() {
    lectures.forEach((fileName, fileurl) => {upload(fileName, fileurl)});
  }

  Future upload(String fileName, String fileurl) async {
    return await course.document(fileName + '>>' + user.uid).setData({
      'title': fileName.split('.').first,
      'url': fileurl,
      'author_name': AutherName,
      'price': price,
    });
  }

  Future uploadfreeCourseData(String fileName, String fileUrl) async {
    return await freeCourse.document(fileName + '>>' + user.uid).setData({
      'title': fileName.split('.').first,
      'url': fileUrl,
      'author_name': AutherName,
      'course_ame': courseName + '>>' + user.uid,
      'price': price,
    });
  }

  Future uploadPaidCoursedata(String fileName, String fileUrl) async {
    return await paidCourse.document(fileName + '>>' + user.uid).setData({
      'title': fileName.split('.').first,
      'url': fileUrl,
      'author_name': AutherName,
      'course_name': courseName + '>>' + user.uid,
      'price': price,
    });
  }

  Future addNewCourseEntry(String uid) async {
    DocumentSnapshot teacherSnapShot =
        await Firestore.instance.collection('teachers').document(uid).get();
    var coursesmadetill = teacherSnapShot['courses_made'];
    return await teachersCollection.document(uid).updateData({
      'courses_made':
          coursesmadetill.toString() + '??.??' + courseName + '>>' + uid
    });
  }
}
