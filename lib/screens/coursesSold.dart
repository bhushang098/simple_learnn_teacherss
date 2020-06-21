import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoursesSold extends StatefulWidget {
  @override
  _CoursesSoldState createState() => _CoursesSoldState();
}

class _CoursesSoldState extends State<CoursesSold> {
  var couesesSold;
  var courseSoldList;
  @override
  Widget build(BuildContext context) {
    couesesSold =
        ModalRoute.of(context).settings.arguments.toString().split('??.??');

    courseSoldList = couesesSold.sublist(1, couesesSold.length);

    return Scaffold(
        backgroundColor: Colors.teal[50],
        appBar: AppBar(
          title: Text('Soled Courses'),
        ),
        body: courseSoldList.length == 0
            ? Center(
                child: Text(
                'No courses Sold \nSince last Redeem',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: courseSoldList.length,
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
                                  print('Got Course >>>>' +
                                      courseSoldList[index]);

                                  //Fluttertoast.showToast(msg: 'course is soled '+)
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.library_books,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                  title: Text(
                                    courseSoldList[index].split('>>').first,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //subtitle: Text(finalList[index].split('>>').last),
                                  subtitle: Text('This Course Soled one time'),
                                  trailing: Icon(
                                    Icons.monetization_on,
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
}
