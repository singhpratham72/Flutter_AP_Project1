import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/services/product_services.dart';
import 'package:ap_ecom_app/services/user_services.dart';
import 'package:ap_ecom_app/widgets/add_review.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:ap_ecom_app/widgets/image_swipe.dart';
import 'package:ap_ecom_app/widgets/product_size.dart';
import 'package:ap_ecom_app/widgets/review_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _selectedProductSize = "0";

  final SnackBar _snackBarCart = SnackBar(
    content: Text("Product added to the cart"),
  );

  final SnackBar _snackBarWishList = SnackBar(
    content: Text("Product added to the wish-list"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                // Firebase Document Data Map
                Map<String, dynamic> documentData = snapshot.data.data();

                // List of images
                List imageList = documentData['images'];
                List productSizes = documentData['size'];

                // Set an initial size
                _selectedProductSize = productSizes[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${documentData['name']}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "\$${documentData['price']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${documentData['desc']}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await addToWishList(
                                  productId: widget.productId,
                                  selectedProductSize: _selectedProductSize);
                              Scaffold.of(context)
                                  .showSnackBar(_snackBarWishList);
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  "assets/images/tab_saved.png",
                                ),
                                height: 22.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await addToCart(
                                    productId: widget.productId,
                                    selectedProductSize: _selectedProductSize,
                                    price: documentData['price']);
                                Scaffold.of(context)
                                    .showSnackBar(_snackBarCart);
                              },
                              child: Container(
                                height: 65.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Customer Reviews',
                                style: Constants.regularHeading
                                    .copyWith(color: Color(0xFFFF1E00)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => AddReview(
                                            productID: widget.productId,
                                          ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    children: [
                                      Text('Add Review'),
                                      Icon(Icons.add)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          FutureBuilder(
                            future: _firebaseServices.productsRef
                                .doc(widget.productId)
                                .collection('Reviews')
                                .get(),
                            builder: (context, reviewSnap) {
                              if (reviewSnap.hasError)
                                return Container(
                                  child: Center(
                                    child: Text('Error: ${reviewSnap.error}'),
                                  ),
                                );
                              if (reviewSnap.connectionState ==
                                  ConnectionState.done) {
                                return ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    top: 20.0,
                                    bottom: 12.0,
                                  ),
                                  children: reviewSnap.data.docs
                                      .map<Widget>((reviewDoc) {
                                    Map<String, dynamic> reviewDocData =
                                        reviewDoc.data();
                                    return ReviewCard(
                                      name: reviewDocData['userName'],
                                      review: reviewDocData['review'],
                                      rating: reviewDocData['rating'],
                                    );
                                  }).toList(),
                                );
                              }
                              return Container(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
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
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
