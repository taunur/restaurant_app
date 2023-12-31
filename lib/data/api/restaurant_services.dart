import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/utils/app_constants.dart';

class RestaurantServices {
  final http.Client client;
  RestaurantServices(this.client);

  Future<SearchResult> getSearch(String query) async {
    final response = await client.get(Uri.parse(
      AppConstants.searchUri + query,
    ));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load getSearchRestaurant');
    }
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final response = await client.get(Uri.parse(AppConstants.getRestaurant));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['restaurants'];
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load allRestaurants');
    }
  }
}
