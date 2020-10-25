import 'package:ap_ecom_app/constants.dart';
import 'package:ap_ecom_app/screens/reviewOrder_page.dart';
import 'package:ap_ecom_app/services/firebase_services.dart';
import 'package:ap_ecom_app/services/user_services.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:ap_ecom_app/widgets/display_details.dart';
import 'package:ap_ecom_app/widgets/edit_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddressConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 108.0),
          child: Column(
            children: [
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
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.only(right: 25.0, left: 25.0),
                          childrenPadding:
                              EdgeInsets.only(bottom: 15.0, left: 25.0),
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 25.0, top: 10.0),
                              child: FlatButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => EditAddress());
                                },
                                child: Container(
                                  height: 45.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewOrderPage()));
                },
                child: Container(
                  height: 45.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        CustomActionBar(
          hasCartButton: false,
          hasBackArrow: true,
          title: "Confirm Address",
        ),
      ]),
    );
  }
}
