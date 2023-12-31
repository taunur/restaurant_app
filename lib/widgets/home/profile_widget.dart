import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_assets.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/utils/result_state.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// photo profil
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              AppAsset.profile,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),

          /// place count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Place",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Consumer<RestaurantProvider>(
                builder: (context, state, _) {
                  return state.state == ResultState.hasData
                      ? Text(
                          "${state.allRestaurants.length} Restaurant",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      : const Text(
                          "waiting..",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                }, // <-- Add this comma to properly close the builder function
              ),
            ],
          ),
        ],
      ),
    );
  }
}
