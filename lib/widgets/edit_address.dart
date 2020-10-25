import 'package:ap_ecom_app/services/user_services.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class EditAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Color(0xff757575),
        ),
        child: Container(
          height: 500.0,
          padding: EdgeInsets.only(left: 30.0, top: 25.0, bottom: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Address',
                style: Constants.regularHeading,
              ),
              EditDetailsContainer(hintText: 'Address Line 1'),
              EditDetailsContainer(hintText: 'Address Line 2'),
              EditDetailsContainer(hintText: 'City'),
              EditDetailsContainer(hintText: 'State'),
              Center(
                child: FlatButton(
                  color: Colors.black,
                  onPressed: () {
                    updateAddress();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditDetailsContainer extends StatelessWidget {
  final String hintText;
  EditDetailsContainer({@required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 35.0),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          focusColor: Colors.grey,
          border: OutlineInputBorder(),
          labelText: hintText,
        ),
        onChanged: (newText) {
          if (hintText == 'Address Line 1')
            address1 = newText;
          else if (hintText == 'Address Line 2')
            address2 = newText;
          else if (hintText == 'City')
            city = newText;
          else if (hintText == 'State') state = newText;
        },
      ),
    );
  }
}
