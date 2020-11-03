import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/home_page.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Order Placed!',
              style: Constants.boldHeading.copyWith(fontSize: 35.0),
            ),
            Text(
              'Your order was successully placed and is being prepared for delivery.',
              style: Constants.regularDarkText
                  .copyWith(fontWeight: FontWeight.w100, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.check_circle,
              size: 300.0,
              color: Color(0xFFFF1E00),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                height: 45.0,
                width: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Center(
                  child: Text(
                    'Continue Shopping',
                    style: Constants.regularDarkText
                        .copyWith(fontWeight: FontWeight.w200),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      CustomActionBar(
        title: 'Order Confirmed',
        hasCartButton: false,
        navigate: false,
      )
    ]));
  }
}
