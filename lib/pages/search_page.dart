import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/widgets/search/item_restaurant_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Schedule the search operation to be performed after the build is complete
    Future.microtask(() {
      Provider.of<RestaurantProvider>(context, listen: false).search('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: _header(),
      body: isLandscape
          ? SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearching(context),
                  _buildList(context),
                ],
              ),
            )
          : Column(
              children: [
                _buildSearching(context),
                _buildList(context),
              ],
            ),
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
        "Search",
        style: whiteTextstyle,
      ),
    );
  }

  /// Searching Text input
  Padding _buildSearching(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              labelText: 'Search Restaurant',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          Provider.of<RestaurantProvider>(context,
                                  listen: false)
                              .search(''); // Trigger to show all restaurants
                        });
                        _searchFocusNode.unfocus();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              Provider.of<RestaurantProvider>(context, listen: false)
                  .search(value);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    /// Use the ternary operator to conditionally apply Expanded
    Widget listWidget = isLandscape

        /// in widgets search
        ? const RestaurantListWidget()
        : const Expanded(
            child: RestaurantListWidget(),
          );

    return listWidget;
  }
}
