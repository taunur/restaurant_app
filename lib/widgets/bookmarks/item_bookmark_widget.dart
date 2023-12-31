import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/provider/db_resto_provider.dart';
import 'package:restaurant_app/data/utils/image_helpers.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRestoProvider>(
      builder: (context, provider, child) {
        return Material(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Hero(
              tag: restaurant.pictureId,
              child: Image.network(
                ImageHelper.getImageUrl(
                  restaurant.pictureId,
                  ImageResolution.small,
                ),
              ),
            ),
            title: Text(
              restaurant.name,
            ),
            subtitle: Text(
              restaurant.city,
            ),
            trailing: FutureBuilder<bool>(
              future: provider.isBookmarked(restaurant.id),
              builder: (context, snapshot) {
                var isBookmarked = snapshot.data ?? false;
                return isBookmarked
                    ? IconButton(
                        icon: const Icon(Icons.bookmark),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => provider.removeBookmark(restaurant.id),
                      )
                    : IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => provider.addBookmarkHome(restaurant),
                      );
              },
            ),
            onTap: () => Navigation.intent(
              AppRoute.details,
              arguments: restaurant.id,
            ),
          ),
        );
      },
    );
  }
}
