import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_assets.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/provider/db_resto_provider.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/utils/image_helpers.dart';
import 'package:restaurant_app/data/utils/result_state.dart';
import 'package:restaurant_app/pages/no_connection.dart';
import 'package:restaurant_app/widgets/error_widget.dart';
import 'package:restaurant_app/widgets/home/profile_widget.dart';
import 'package:restaurant_app/widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refresh(BuildContext context) async {
    /// Check if the widget is mounted before updating the state
    if (mounted) {
      await Provider.of<RestaurantProvider>(context, listen: false).refresh();
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
    int crossAxisCount =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;

    return Scaffold(
      appBar: _header(),
      body: Column(
        children: [
          //// Profile widget home
          const Profile(),

          //// all restaurant
          _buildItemRestaurant(crossAxisCount),
        ],
      ),
    );
  }

  /// Appbar
  AppBar _header() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColor.secondary,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAsset.logow,
            width: 52,
          ),
          Center(
            child: Text(
              "RestoApp",
              style: whiteTextstyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRestaurant(int crossAxisCount) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Loading();
            } else if (state.state == ResultState.hasData) {
              return _buildRestaurantGridView(context, crossAxisCount, state);
            } else if (state.state == ResultState.noData) {
              return ErrorMessageWidget(message: state.message);
            } else if (state.state == ResultState.error) {
              if (state.message == 'No internet connection') {
                return const NoConnectionPage();
              } else {
                return ErrorMessageWidget(message: state.message);
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantGridView(
      BuildContext context, int crossAxisCount, RestaurantProvider state) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8.0,
        ),
        itemCount: state.allRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = state.allRestaurants[index];
          int fullStars = restaurant.rating.floor();
          double remainingFraction = restaurant.rating - fullStars;

          return GestureDetector(
            onTap: () {
              Navigation.intent(
                AppRoute.details,
                arguments: restaurant.id,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Hero(
                        tag: restaurant.pictureId,
                        child: Image.network(
                          ImageHelper.getImageUrl(
                            restaurant.pictureId,
                            ImageResolution.small,
                          ),
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, _) => const Center(
                            child: Icon(Icons.error),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.black87,
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Row(
                          children: [
                            for (int i = 0; i < fullStars; i++)
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            if (remainingFraction > 0)
                              const Icon(
                                Icons.star_half,
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                Text(
                                  restaurant.city,
                                  style: whiteTextstyle,
                                ),
                              ],
                            ),
                          ),
                          Consumer<DatabaseRestoProvider>(
                            builder: (context, provider, child) {
                              return FutureBuilder<bool>(
                                future: provider.isBookmarked(restaurant.id),
                                builder: (context, snapshot) {
                                  var isBookmarked = snapshot.data ?? false;
                                  return isBookmarked
                                      ? IconButton(
                                          icon: const Icon(Icons.bookmark),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () => provider
                                              .removeBookmark(restaurant.id),
                                        )
                                      : IconButton(
                                          icon:
                                              const Icon(Icons.bookmark_border),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onPressed: () => provider
                                              .addBookmarkHome(restaurant),
                                        );
                                },
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    restaurant.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
