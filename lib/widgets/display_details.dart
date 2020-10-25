import 'package:flutter/material.dart';

import '../constants.dart';

class DisplayDetailsContainer extends StatelessWidget {
  final String text, hintText;
  DisplayDetailsContainer({this.text, @required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              hintText,
              style: Constants.lightHeading,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              margin: EdgeInsets.only(right: 30.0),
              height: 42.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0),
              )),
        ],
      ),
    );
  }
}
