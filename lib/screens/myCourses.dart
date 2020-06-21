import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  var courseList;
  var finalList;

  @override
  Widget build(BuildContext context) {
    courseList =
        ModalRoute.of(context).settings.arguments.toString().split('??.??');
    finalList = courseList.sublist(1, courseList.length);
    return Scaffold(
        backgroundColor: Colors.teal[50],
        appBar: AppBar(
          title: Text('Your Courses'),
        ),
        body: finalList.length == 0
            ? Center(
                child: Text(
                'No Creations Till',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: finalList.length,
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
                                  print('Got Course >>>>' + finalList[index]);

                                  navToMyCourseDetails(finalList[index]);
//                          navToPurchasedCourseDetailsPage(
//                              finalList[index]);

                                  // Get CourseDetails
                                  //navtoVidScreen(widget._vidList[index]);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.library_books,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    finalList[index].split('>>').first,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //subtitle: Text(finalList[index].split('>>').last),
                                  subtitle:
                                      Text('You Have Published this Course'),
                                  trailing: Icon(
                                    Icons.done_all,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      );
                    }),
              ));
  }

  void navToMyCourseDetails(courseName) {
    Navigator.pushNamed(context, '/myCourseDetails', arguments: courseName);
  }
}
