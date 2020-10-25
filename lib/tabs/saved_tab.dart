import 'package:ap_ecom_app/screens/wishlist_page.dart';
import 'package:ap_ecom_app/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: WishListPage(),
          ),
          CustomActionBar(
            title: "Wishlist",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
