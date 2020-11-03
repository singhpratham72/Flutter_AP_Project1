import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:ap_ecom_app/widgets/order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FutureBuilder<QuerySnapshot>(
        future: _firebaseServices.usersRef
            .doc(_firebaseServices.getUserId())
            .collection('Orders')
            .get(),
        builder: (context, ordersSnap) {
          if (ordersSnap.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${ordersSnap.error}"),
              ),
            );
          }

          // Collection Data ready to display
          if (ordersSnap.connectionState == ConnectionState.done) {
            if (ordersSnap.hasData) {
              print('Data hai');
              // Display the data inside a list view
              return ListView(
                padding: EdgeInsets.only(
                  top: 108.0,
                  bottom: 12.0,
                ),
                children: ordersSnap.data.docs.map((document) {
                  return OrderCard(
                      orderId: document.id,
                      total: document.data()['amount'],
                      timestamp: document.data()['timestamp'],
                      items: document.data()['items']);
                }).toList(),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Text(
                    'You have not placed any orders yet.',
                    style: Constants.regularDarkText,
                  ),
                ),
              );
            }
          }

          // Loading State
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      CustomActionBar(
        title: 'Your Orders',
        hasCartButton: false,
        hasBackArrow: true,
      )
    ]));
  }
}
