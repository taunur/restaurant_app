import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/connection_services.dart';
import 'package:restaurant_app/data/db/db_resto_helper.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';

import 'package:restaurant_app/data/utils/result_state.dart';

class DatabaseRestoProvider extends ChangeNotifier {
  final DatabaseRestoHelper databaseHelper;
  final ConnectionServices connectionServices;

  DatabaseRestoProvider({
    required this.databaseHelper,
    required this.connectionServices,
  }) {
    _getBookmarks();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _bookmarks = [];
  List<Restaurant> get bookmarks => _bookmarks;

  /// mendapatkan data bookmark dari database
  Future<void> _getBookmarks() async {
    _state = ResultState.loading;
    _message = '';
    notifyListeners();

    /// Check for connectivity
    if (!(await connectionServices.isInternetAvailable())) {
      _handleNoConnection();
      return;
    }

    _bookmarks = await databaseHelper.getBookmarksResto();
    if (_bookmarks.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Bookmarks have not been added';
    }
    notifyListeners();
  }

  /// menambahkan bookmark
  Future<void> addBookmarkHome(Restaurant restaurant) async {
    try {
      await databaseHelper.insertBookmarkResto(restaurant);
      _getBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarkedArticle = await databaseHelper.getBookmarkById(id);
    return bookmarkedArticle.isNotEmpty;
  }

  Future<void> removeBookmark(String id) async {
    try {
      await databaseHelper.removeBookmark(id);
      _getBookmarks();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _getBookmarks();
  }

  Future<void> _handleNoConnection() async {
    _state = ResultState.error;
    _message = 'No internet connection';
    notifyListeners();
  }

  Future<void> handleNoConnection() async {
    await _handleNoConnection();
  }
}
