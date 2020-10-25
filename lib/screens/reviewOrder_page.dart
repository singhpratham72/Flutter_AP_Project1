import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/orderComplete_page.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/services/product_services.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();

    return Scaffold(
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.usersRef
                    .doc(_firebaseServices.getUserId())
                    .collection("Cart")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  // Collection Data ready to display
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Display the data inside a list view
                    return ListView(
                      padding: EdgeInsets.only(
                        top: 108.0,
                        bottom: 12.0,
                      ),
                      children: snapshot.data.docs.map((document) {
                        return FutureBuilder(
                          future: _firebaseServices.productsRef
                              .doc(document.id)
                              .get(),
                          builder: (context, productSnap) {
                            if (productSnap.hasError) {
                              return Container(
                                child: Center(
                                  child: Text("${productSnap.error}"),
                                ),
                              );
                            }

                            if (productSnap.connectionState ==
                                ConnectionState.done) {
                              Map _productMap = productSnap.data.data();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 0.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          "${_productMap['images'][0]}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_productMap['name']}",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: Text(
                                              "\$${_productMap['price']}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Text(
                                            "Size - ${document.data()['size']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'x 1',
                                      style: Constants.regularHeading,
                                    )
                                  ],
                                ),
                              );
                            }

                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  }

                  // Loading State
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 150.0,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1.0,
                      blurRadius: 30.0,
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u2022 Pay with Cash on Delivery',
                        style: Constants.regularHeading,
                      ),
                      FutureBuilder<int>(
                        future: getCartTotal(),
                        builder: (context, total) {
                          return total.hasData
                              ? Text(
                                  '\$${total.data}.0',
                                  style: Constants.regularHeading
                                      .copyWith(fontSize: 21.0),
                                )
                              : Text('\$...',
                                  style: Constants.regularHeading
                                      .copyWith(fontSize: 21.0));
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (await getCartTotal() != 0) {
                          await createOrder();
                          await deleteCart();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderCompletePage()));
                        }
                      },
                      child: Container(
                        width: 250.0,
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFFF1E00),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Center(
                          child: Text(
                            'Place Order',
                            style: Constants.regularHeading
                                .copyWith(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
        CustomActionBar(
          hasCartButton: false,
          hasBackArrow: true,
          title: "Review Order",
        )
      ]),
    );
  }
}
