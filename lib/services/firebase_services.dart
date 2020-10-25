import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");

  Future<dynamic> fetchUserData({String query}) async {
    Map<dynamic, dynamic> userData = await usersRef
        .doc(getUserId())
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    if (query == 'name')
      return userData['name'].toString();
    else if (query == 'phone')
      return userData['phone'].toString();
    else if (query == 'addressLine1')
      return userData['addressLine1'].toString();
    else if (query == 'addressLine2')
      return userData['addressLine2'].toString();
    else if (query == 'city')
      return userData['city'].toString();
    else if (query == 'state')
      return userData['state'].toString();
    else
      return "";
  }

  Future<int> fetchProductPrice(String productId) async {
    Map<dynamic, dynamic> productData = await productsRef
        .doc(productId)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    return (productData['price']);
  }

  Future<String> fetchUserName(String userId) async {
    Map<dynamic, dynamic> userData = await usersRef
        .doc(userId)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data());
    return (userData['name']);
  }
}
