import 'package:ap_ecom_app/constants.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String review, name;
  final int rating;
  ReviewCard({this.review, this.name, this.rating});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.black)),
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
            style: Constants.regularHeading,
          ),
          Text(
            '$rating/5',
            style: Constants.boldHeading
                .copyWith(color: Color(0xFFFF1E00), fontSize: 20.0),
          ),
          Text(
            review,
            style:
                Constants.regularDarkText.copyWith(fontWeight: FontWeight.w100),
          )
        ]));
  }
}
