import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/utils/image_helpers.dart';
import 'package:restaurant_app/data/utils/result_state.dart';
import 'package:restaurant_app/pages/no_connection.dart';
import 'package:restaurant_app/widgets/error_widget.dart';
import 'package:restaurant_app/widgets/loading_widget.dart';

class RestaurantListWidget extends StatelessWidget {
  const RestaurantListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Consumer<RestaurantProvider>(
      builder: (context, search, _) {
        switch (search.state) {
          case ResultState.loading:
            return const Loading();
          case ResultState.hasData:
            if (search.result != null) {
              return ListView.builder(
                shrinkWrap: isLandscape,
                physics: isLandscape
                    ? const NeverScrollableScrollPhysics()
                    : null, // Apply physics conditionally
                itemCount: search.result!.restaurants.length,
                itemBuilder: (context, index) {
                  var searchResto = search.result!.restaurants[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: Hero(
                      tag: searchResto.pictureId,
                      child: Image.network(
                        ImageHelper.getImageUrl(
                          searchResto.pictureId,
                          ImageResolution.small,
                        ),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      searchResto.name,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchResto.city,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            Text(
                              searchResto.rating.toString(),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigation.intent(
                        AppRoute.details,
                        arguments: searchResto.id,
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No restaurants found"),
              );
            }
          case ResultState.noData:
            return ErrorMessageWidget(message: search.message);
          case ResultState.error:
            if (search.message == 'No internet connection') {
              return Center(
                child: NoConnectionPage(
                  onReload: () {
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .refresh();
                  },
                ),
              );
            } else {
              return ErrorMessageWidget(message: search.message);
            }
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
