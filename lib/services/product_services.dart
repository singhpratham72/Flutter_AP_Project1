import 'package:ap_ecom_app/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../constants.dart';
import 'firebase_services.dart';
import 'package:uuid/uuid.dart';

FirebaseServices _firebaseServices = FirebaseServices();

Future addToCart(
    {@required String productId,
    @required selectedProductSize,
    @required int price}) async {
  return _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection("Cart")
      .doc(productId)
      .set({"size": selectedProductSize});
}

Future deleteFromCart({@required String productId}) {
  return _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection("Cart")
      .doc(productId)
      .delete();
}

Future deleteCart() async {
  return await _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection("Cart")
      .get()
      .then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  });
}

Future addReview({String productID, String review, int rating}) async {
  Map<String, dynamic> reviewData = {
    'review': review,
    'rating': rating,
    'userName': name
  };
  return await _firebaseServices.productsRef
      .doc(productID)
      .collection('Reviews')
      .doc(_firebaseServices.getUserId())
      .set(reviewData);
}

Future createOrder() async {
  var uuid = Uuid();
  String orderID = uuid.v1();

  Map<String, dynamic> orderData = {
    'items': await getCartItemList(),
    'amount': await getCartTotal(),
    'address1': address1,
    'address2': address2,
    'city': city,
    'state': state,
    'timestamp': Timestamp.now(),
  };

  print('Order Created');

  return await _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection("Orders")
      .doc(orderID)
      .set(orderData);
}

Future getCartItemList() async {
  List<Map> cartItems = [];
  QuerySnapshot snapshot = await _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection('Cart')
      .get();
  for (DocumentSnapshot product in snapshot.docs) {
    String selectedProductSize = await product.get('size');
    String productID = product.id;
    Map<String, String> cartProduct = {
      'productId': productID,
      'size': selectedProductSize
    };
    cartItems.add(cartProduct);
  }
  return cartItems;
}

Future addToWishList(
    {@required String productId, @required selectedProductSize}) {
  return _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection("WishList")
      .doc(productId)
      .set({"size": selectedProductSize});
}

Future<int> getProductPrice(String productID) async {
  DocumentSnapshot snapshot =
      await _firebaseServices.productsRef.doc(productID).get();
  Map product = snapshot.data();
  print('ProductPrice: ${product['price']}');
  return product['price'];
}

Future<String> getProductName(String productID) async {
  DocumentSnapshot snapshot =
      await _firebaseServices.productsRef.doc(productID).get();
  Map product = snapshot.data();
  print('ProductName: ${product['name']}');
  return product['name'];
}

Future<int> getCartTotal() async {
  int total = 0;
  QuerySnapshot snapshot = await _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .collection('Cart')
      .get(); // snapshot has all the documents in the current user's cart
  List cartProducts = snapshot.docs;
  for (QueryDocumentSnapshot product in cartProducts) {
    int price = await getProductPrice(product.id);
    total = total + price;
  }
  return total;
}

// Future createProduct() async {
//   // var uuid = Uuid();
//   // String productID = uuid.v1();
//
//   Map<String, dynamic> productData = {
//     'name': 'DAP Denim Shorts',
//     'desc':
//         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     'price': 999,
//     'images': [
//       'https://firebasestorage.googleapis.com/v0/b/advancedprogramming-e94cf.appspot.com/o/tshirts%2Fpexels-andrea-piacquadio-3775119.jpg?alt=media&token=a7c9535c-a471-44f3-a14f-6faf71c621cf',
//       'https://firebasestorage.googleapis.com/v0/b/advancedprogramming-e94cf.appspot.com/o/tshirts%2Fpexels-andrea-piacquadio-3775119.jpg?alt=media&token=a7c9535c-a471-44f3-a14f-6faf71c621cf'
//     ],
//     'search_string': 'dapdenimshorts',
//     'size': ['S', 'M', 'L', 'XL']
//   };
//
//   print('Product Created');
//
//   return await _firebaseServices.productsRef.doc().set(productData);
// }
