import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/myOrders_page.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/widgets/display_details.dart';
import 'package:ap_ecom_app/widgets/edit_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_ecom_app/services/user_services.dart';

class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 30.0),
          width: double.infinity,
          height: 225.0,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(300.0)),
          ),
          child: Text(
            'Hello,\n$name.',
            style: Constants.regularHeading
                .copyWith(fontSize: 32, color: Colors.white),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 30.0, left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTileTheme(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  child: Theme(
                    data: theme,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.only(right: 25.0),
                      childrenPadding: EdgeInsets.only(bottom: 15.0),
                      title: Text(
                        "Personal",
                        style: Constants.regularHeading,
                      ),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                      ),
                      children: [
                        DisplayDetailsContainer(
                          text: name,
                          hintText: "Name",
                        ),
                        DisplayDetailsContainer(
                          text: phone,
                          hintText: "Phone",
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 20.0,
                  color: Colors.black38,
                ),
                // Add text fields for address
                StreamBuilder(
                    stream: _firebaseServices.usersRef
                        .doc(_firebaseServices.getUserId())
                        .snapshots(),
                    builder: (context, snapshot) {
                      return ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                        child: Theme(
                          data: theme,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.only(right: 25.0),
                            childrenPadding: EdgeInsets.only(bottom: 15.0),
                            title: Text(
                              "Address",
                              style: Constants.regularHeading,
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            children: [
                              DisplayDetailsContainer(
                                text: address1,
                                hintText: "Address Line 1",
                              ),
                              DisplayDetailsContainer(
                                text: address2,
                                hintText: "Address Line 2",
                              ),
                              DisplayDetailsContainer(
                                text: city,
                                hintText: "City",
                              ),
                              DisplayDetailsContainer(
                                text: state,
                                hintText: "State",
                              ),
                              FlatButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => EditAddress());
                                },
                                color: Colors.black,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                Divider(
                  height: 20.0,
                  color: Colors.black38,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrdersPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "My Orders",
                      style: Constants.regularHeading,
                    ),
                  ),
                ),
                Divider(
                  height: 20.0,
                  color: Colors.black38,
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Log Out",
                      style:
                          Constants.regularHeading.copyWith(color: Colors.red),
                    ),
                  ),
                ),
                Divider(
                  height: 20.0,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
