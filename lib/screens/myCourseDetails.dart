import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplelearnnteacherss/screens/getCourseDetails.dart';

class MyCourseDetails extends StatefulWidget {
  @override
  _MyCourseDetailsState createState() => _MyCourseDetailsState();
}

class _MyCourseDetailsState extends State<MyCourseDetails> {
  String courseName;
  ScreenArgs args;
  List<DocumentSnapshot> snapshot;

  Future getMyCourse(String courseName) async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection(courseName).getDocuments();
    snapshot = qn.documents;
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    courseName = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        backgroundColor: Colors.teal,
        onPressed: () {
          //open upload Activity
          args = new ScreenArgs(user, courseName.split('>>').first,
              snapshot[0].data['author_name'], snapshot[0].data['price']);
          navToAddInCourse(args);
        },
      ),
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text(courseName.split('>>').first),
      ),
      body: FutureBuilder(
        future: getMyCourse(courseName),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return ListView.builder(
                itemCount: snapShot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.teal[100],
                            onTap: () {
                              print('Got url >>>>' +
                                  snapShot.data[index].data['url']);
//                              navToNewVidScreen(new VideoClass(
//                                  snapShot.data[index].data['title'],
//                                  snapShot.data[index].data['url'],
//                                  snapShot.data[index].data['author_name'],
//                                  snapShot.data[index]
//                                      .data[courseName.split('>>').first],
//                                  snapShot.data[index].data['price']));
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.video_library,
                                size: 50,
                                color: Colors.green,
                              ),
                              title: Text(
                                snapShot.data[index].data['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              //subtitle: Text(finalList[index].split('>>').last),
                              subtitle: Text(
                                  snapShot.data[index].data['author_name']),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }

  void navToAddInCourse(ScreenArgs args) {
    Navigator.pushNamed(context, '/AddInCourse', arguments: args);
  }
}
