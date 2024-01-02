import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/data/provider/db_resto_provider.dart';
import 'package:restaurant_app/data/utils/result_state.dart';
import 'package:restaurant_app/pages/no_connection.dart';
import 'package:restaurant_app/widgets/bookmarks/empty_bookmark_widget.dart';
import 'package:restaurant_app/widgets/bookmarks/item_bookmark_widget.dart';
import 'package:restaurant_app/widgets/error_widget.dart';
import 'package:restaurant_app/widgets/loading_widget.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  Future<void> _refresh(BuildContext context) async {
    /// Check if the widget is mounted before updating the state
    if (mounted) {
      await Provider.of<DatabaseRestoProvider>(context, listen: false)
          .refresh();
    }
  }

  @override
  void initState() {
    super.initState();

    /// Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          /// Reload data when the internet connection is restored
          _refresh(context);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: _buildListView(provider),
        );
      },
    );
  }

  Widget _buildListView(DatabaseRestoProvider provider) {
    if (provider.state == ResultState.loading) {
      return const Loading();
    } else if (provider.state == ResultState.hasData) {
      return ListView.builder(
        itemCount: provider.bookmarks.length,
        itemBuilder: (context, index) {
          return CardRestaurant(restaurant: provider.bookmarks[index]);
        },
      );
    } else if (provider.state == ResultState.error) {
      if (provider.message == 'No internet connection') {
        return NoConnectionPage(
          onReload: () {
            Provider.of<DatabaseRestoProvider>(context, listen: false)
                .refresh();
          },
        );
      } else {
        return ErrorMessageWidget(message: provider.message);
      }
    } else {
      return EmptyDataWidget(
        message: provider.message,
        imagePath: "assets/images/confused.png",
      );
    }
  }
}
