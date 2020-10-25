import 'firebase_services.dart';

FirebaseServices _firebaseServices = FirebaseServices();

String name, phone, address1, address2, city, state;

void assignUserData() async {
  name = await _firebaseServices.fetchUserData(query: 'name');
  phone = await _firebaseServices.fetchUserData(query: 'phone');
  address1 = await _firebaseServices.fetchUserData(query: 'addressLine1');
  address2 = await _firebaseServices.fetchUserData(query: 'addressLine2');
  city = await _firebaseServices.fetchUserData(query: 'city');
  state = await _firebaseServices.fetchUserData(query: 'state');
}

Future<void> updateAddress() async {
  return await _firebaseServices.usersRef
      .doc(_firebaseServices.getUserId())
      .update({
    'addressLine1': address1,
    'addressLine2': address2,
    'city': city,
    'state': state
  });
}
