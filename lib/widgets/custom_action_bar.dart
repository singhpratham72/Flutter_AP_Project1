import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/cart_page.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;
  final bool navigate;
  final bool hasCartButton;
  CustomActionBar(
      {this.title,
      this.hasBackArrow,
      this.hasTitle,
      this.hasBackground,
      this.navigate = true,
      this.hasCartButton = true});

  final FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hasTitle = hasTitle ?? true;
    bool _hasBackground = hasBackground ?? true;

    return Container(
      decoration: BoxDecoration(
          gradient: _hasBackground
              ? LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                )
              : null),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/back_arrow.png"),
                  color: Colors.white,
                  width: 16.0,
                  height: 16.0,
                ),
              ),
            ),
          if (_hasTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.boldHeading,
            ),
          if (hasCartButton)
            GestureDetector(
              onTap: () {
                if (navigate) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ));
                }
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: StreamBuilder(
                  stream: _usersRef
                      .doc(_firebaseServices.getUserId())
                      .collection("Cart")
                      .snapshots(),
                  builder: (context, snapshot) {
                    int _totalItems = 0;

                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        List _documents = snapshot.data.docs;
                        _totalItems = _documents.length;
                      }
                    }

                    return Text(
                      "$_totalItems" ?? "0",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            )
          else
            SizedBox(
              width: 42.0,
            )
        ],
      ),
    );
  }
}
