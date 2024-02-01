import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/review_services.dart';
import 'package:restaurant_app/data/models/review_model.dart';
import 'package:restaurant_app/data/utils/result_state.dart';

class ReviewProvider with ChangeNotifier {
  ResultState _state = ResultState.noData;
  Review? _addedReview;
  String _message = '';

  String get message => _message;
  Review? get addedReview => _addedReview;
  ResultState get state => _state;

  Future<void> addReview(String id, String name, String review) async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      final response = await ReviewService.addReview(id, name, review);

      if (!response.error) {
        _addedReview = response.customerReviews.last as Review?; // Assuming the latest review is added
        _state = ResultState.hasData;
        _message = 'Review added successfully';
      } else {
        _state = ResultState.error;
        _message = response.message;
      }

      notifyListeners();
    } catch (error) {
      _state = ResultState.error;
      _message = 'Failed to add review: $error';
      notifyListeners();
    }
  }
}
