import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/product_page.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final Timestamp timestamp;
  final List items;
  final int total;
  OrderCard({this.orderId, this.timestamp, this.items, this.total});

  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    String date = timestamp.toDate().toString();
    date = date.substring(0, 10);

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black)),
      margin: EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 24.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Order ID: $orderId',
          style: Constants.regularHeading.copyWith(fontSize: 14.0),
        ),
        SizedBox(
          height: 10.0,
        ),
        for (Map item in items)
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(item['productId']).get(),
            builder: (context, AsyncSnapshot productSnap) {
              if (productSnap.hasError) return Text(productSnap.error);
              if (productSnap.connectionState == ConnectionState.done)
                return Text(
                  '\u2022 ${productSnap.data.data()['name']}',
                  style: Constants.regularDarkText
                      .copyWith(fontWeight: FontWeight.w100),
                );
              return CircularProgressIndicator();
            },
          ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: Constants.regularHeading,
            ),
            Text(
              '\$ ${total.toString()}',
              style:
                  Constants.regularHeading.copyWith(color: Color(0xFFFF1E00)),
            )
          ],
        ),
      ]),
    );
  }
}
