import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/connection_services.dart';
import 'package:restaurant_app/data/api/details_services.dart';
import 'package:restaurant_app/data/models/detail_resto_model.dart';
import 'package:restaurant_app/data/utils/result_state.dart';

class DetailRestoProvider extends ChangeNotifier {
  DetailResto? _detailResto;
  ResultState _state = ResultState.loading;
  String _errorMessage = '';

  DetailResto? get detailResto => _detailResto;
  ResultState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchDetailResto(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final connectionServices = ConnectionServices();

      /// Check for connectivity
      if (!(await connectionServices.isInternetAvailable())) {
        /// No internet connection
        _handleNoConnection();
        return;
      }

      /// Assuming that DetailRestoApi.fetchDetailResto returns a Future<DetailResto>
      _detailResto = await DetailRestoService.fetchDetailResto(id);

      _state = ResultState.hasData;
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = 'Failed to load restaurant check your connection';
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleNoConnection() async {
    _state = ResultState.error;
    _errorMessage = 'No internet connection';
    notifyListeners();
  }
}
