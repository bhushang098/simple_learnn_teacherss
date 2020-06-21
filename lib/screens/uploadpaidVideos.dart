import 'dart:collection';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simplelearnnteacherss/services/dbCollectinService.dart';
import '../main.dart';
import 'getCourseDetails.dart';

class UploadPaidVid extends StatefulWidget {
  @override
  _UploadPaidVidState createState() => _UploadPaidVidState();
}

class _UploadPaidVidState extends State<UploadPaidVid> {
  Map<String, String> _pats;
  HashMap<String, String> _lectures = new HashMap();
  String _extension;
  ScreenArgs args;
  final coursenameController = TextEditingController();
  List<String> fileNames = [];
  DbCoursesCollection collection;

  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  openFileExplorer(FirebaseUser user) async {
    try {
      _pats = await FilePicker.getMultiFilePath(
        type: FileType.video,
        // allowedExtensions: [_extension],
      );
      uploadToFireBase(user);
    } on PlatformException catch (e) {
      print('UnSupported operation ' + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFireBase(FirebaseUser user) {
    _pats.forEach((fileName, filePath) => {upload(fileName, filePath, user)});
  }

  upload(String fileName, String filePath, FirebaseUser user) async {
    _extension = fileName.toString().split('.').last;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(args.courseName + '>>' + user.uid)
        .child(fileName);

    fileNames.add(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filePath),
        StorageMetadata(
          contentType: '$FileType.videos/$_extension',
        ));

    setState(() {
      _tasks.add(uploadTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());
    final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        //onDownload: () => downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Upload Paid Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            OutlineButton(
              color: Colors.red[100],
              child: Text('Upload Paid Videos'),
              onPressed: () {
                // user = await _auth.signInanon();
                openFileExplorer(args.user);
                //commitTofireStore(courseName, user);
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: ListView(
                children: children,
              ),
            ),
            OutlineButton(
              child: Text('Publish Course'),
              onPressed: () {
                if (_tasks.length == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text('upload Videos first'),
                      );
                    },
                  );
                } else if (_tasks.length >= 2) {
                  commitTofireStore(args.courseName, args.user);
                }
                // user = await _auth.signInanon();
              },
            )
          ],
        ),
      ),
    );
  }

  void commitTofireStore(String courseName, FirebaseUser user) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(courseName + '>>' + user.uid);

    for (int i = 0; i < fileNames.length; i++) {
      var fileurl =
          await firebaseStorageRef.child(fileNames[i]).getDownloadURL();

      _lectures.putIfAbsent(fileNames[i], () => fileurl);
      //print('>>>>>>>>>>&*&()&()&(*&(&>>>>>>>>>' + fileurl);
    }

    collection = new DbCoursesCollection(
        args.courseName, args.user, _lectures, args.authorName, args.price);
    collection.PushLectureDeta();
    //collection.pushFreeeVideosData();
    collection.pushpaidVideosData();
    collection.addNewCourseEntry(user.uid);
    //TODO : updates teacher s data  in firestor
    showAlertDialog(context);

    // Get all deta of bucket and call set Dopcument method for each video in bucket
//    final CollectionReference course = Firestore.instance.collection(courseName);
//    course.document()
  }

  navToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/TeachersMain', (Route<dynamic> route) => false);
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Return Home"),
      onPressed: () {
        Navigator.of(context).pop();
        navToHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Published "),
      content: Text(
          "your course is now Available to All.. \n See This course in Your Courses Option"),
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
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task # ${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
