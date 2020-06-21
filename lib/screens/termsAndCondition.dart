import 'package:flutter/material.dart';

class TermsCondition extends StatefulWidget {
  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          children: <Widget>[
            Text(
              'Welcome To simple learning \n\n    By Accessing this application we Assume you accept these terms and conditions in full \n   All terms refer to the offer acceptance and consideration of payment necessary to undertake the process of our assistance to the client in the most appropriate manner , weather by formal meeting of a fixed  duration or any other means \n\n    we shall have responsibility or liability of any content appearing on our application . You agree to indemnify and defend as against all claims arising out of our based upon your application , No links may appear on any page on your application within any context containing content \n\n\n we provide our best video content helpful to all level of students from middle class to higher educational studies ... ',
              style: TextStyle(fontSize: 16, color: Colors.teal),
            )
          ],
        ),
      ),
    );
  }
}
