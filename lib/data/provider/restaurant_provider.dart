import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/connection_services.dart';
import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantServices restaurantServices;
  final ConnectionServices connectionServices;

  ResultState _state = ResultState.noData;

  RestaurantProvider({
    required this.restaurantServices,
    required this.connectionServices,
  }) {
    _getRestaurant();
  }

  List<Restaurant> _allRestaurants = [];
  List<Restaurant> get allRestaurants => _allRestaurants;

  SearchResult? _searchResult;
  String _message = '';

  String get message => _message;

  SearchResult? get result => _searchResult;

  ResultState get state => _state;

  Future<void> _getRestaurant() async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      // Check for connectivity
      if (!(await connectionServices.isInternetAvailable())) {
        await _handleNoConnection();
        return;
      }

      final restaurantResult = await restaurantServices.getAllRestaurants();

      if (restaurantResult.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        _allRestaurants = restaurantResult;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load restaurant. Check your connection.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleNoConnection() async {
    _state = ResultState.error;
    _message = 'No internet connection';
    notifyListeners();
  }

  Future<void> refresh() async {
    await _getRestaurant();
  }

  Future<void> search(String query) async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      // Check for connectivity
      if (!(await connectionServices.isInternetAvailable())) {
        await _handleNoConnection();
        return;
      }

      final searchResult = await restaurantServices.getSearch(query);

      if (searchResult.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'No restaurant name found: "$query"';
      } else {
        _state = ResultState.hasData;
        _searchResult = searchResult;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load restaurant check your connection';
    } finally {
      notifyListeners();
    }
  }

  Future<void> getRestaurant() async {
    await _getRestaurant();
  }

  // Tambahkan metode publik untuk memanggil _handleNoConnection
  Future<void> handleNoConnection() async {
    await _handleNoConnection();
  }
}
