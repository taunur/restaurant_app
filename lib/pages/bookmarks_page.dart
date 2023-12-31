import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/data/provider/db_resto_provider.dart';
import 'package:restaurant_app/data/utils/result_state.dart';
import 'package:restaurant_app/widgets/bookmarks/empty_bookmark_widget.dart';
import 'package:restaurant_app/widgets/bookmarks/item_bookmark_widget.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(),
      body: _buildList(),
    );
  }

  /// Appbar
  AppBar _header() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColor.secondary,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Bookmarks",
        style: whiteTextstyle,
      ),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseRestoProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.bookmarks[index]);
            },
          );
        } else {
          return EmptyDataWidget(
            message: provider.message,
            imagePath: "assets/images/confused.png",
          );
        }
      },
    );
  }
}
