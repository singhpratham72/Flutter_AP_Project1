import 'package:ap_ecom_app/services/product_services.dart';
import 'package:ap_ecom_app/services/user_services.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

String review = "";
int selectedRating = 5;

class AddReview extends StatelessWidget {
  final String productID;
  AddReview({@required this.productID});
  @override
  Widget build(BuildContext context) {
    review = "";
    selectedRating = 5;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Color(0xff757575),
        ),
        child: Container(
          height: 350.0,
          padding: EdgeInsets.only(left: 30.0, top: 25.0, bottom: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate this product',
                style: Constants.regularHeading,
              ),
              ReviewRating(
                onSelected: (rating) {
                  selectedRating = rating;
                },
              ),
              EditReviewContainer(),
              Center(
                child: FlatButton(
                  color: Colors.black,
                  onPressed: () async {
                    await addReview(
                        productID: productID,
                        rating: selectedRating,
                        review: review);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditReviewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 35.0),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          focusColor: Colors.grey,
          border: OutlineInputBorder(),
          labelText: 'Write your review here.',
        ),
        onChanged: (newText) {
          review = newText;
        },
      ),
    );
  }
}

class ReviewRating extends StatefulWidget {
  final Function(int) onSelected;
  ReviewRating({this.onSelected});

  @override
  _ReviewRatingState createState() => _ReviewRatingState();
}

class _ReviewRatingState extends State<ReviewRating> {
  int _selected = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () {
              widget.onSelected(i);
              setState(() {
                _selected = i;
              });
            },
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: _selected == i
                    ? Theme.of(context).accentColor
                    : Color(0xFFDCDCDC),
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Text(
                "$i",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _selected == i ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          )
      ],
    );
  }
}
