import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ReedemRequest extends StatefulWidget {
  @override
  _ReedemRequestState createState() => _ReedemRequestState();
}

class _ReedemRequestState extends State<ReedemRequest> {
  int balance;
  DocumentSnapshot snapshot;
  TextEditingController cuipId = new TextEditingController();
  String upi_No;

  @override
  Widget build(BuildContext context) {
    balance = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Redeem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                children: <Widget>[
                  Text(
                      'Provide Your UPI id or Phone Number Linked with Google pay or Phone pay to get Your payment')
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UPI ID / Phone No',
              ),
              controller: cuipId,
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              color: Colors.teal,
              onPressed: () {
                upi_No = cuipId.text;
                if (upi_No.isEmpty) {
                  Fluttertoast.showToast(
                      msg: 'Provide UPI id or Mobile Number');
                } else {
                  showConformBox(context, user);
                }
              },
              child: const Text(
                'Make Request',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showConformBox(BuildContext context, FirebaseUser user) {
    Widget okButton = FlatButton(
      child: Text("Yes Conform"),
      onPressed: () {
        Navigator.pop(context);
        makeReedemrequest(user, balance, upi_No, user.uid).then((onValue) {
          showCongatsBox(context);
        });
        //navToHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conformation"),
      content: Text(
          "do U really want to make redeem request of ${balance} Rs \n make sure U entered Correct Upi Id or Phone Number "),
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

  void showCongatsBox(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Return Home"),
      onPressed: () {
        Navigator.pop(context);
        navToHome();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thank You"),
      content: Text("U will get Your payment within 4 - 5  working days"),
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

  Future makeReedemrequest(
      FirebaseUser user, int balance, String upi_no, String doc_id) async {
    CollectionReference requestCollection =
        Firestore.instance.collection('payment_request');
    return await requestCollection.document(user.uid).setData({
      'amount': balance.toString(),
      'email': user.email,
      'upi_phone': upi_no,
      'doc_id': doc_id,
    });
  }

  void navToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/TeachersMain', (Route<dynamic> route) => false);
  }
}
