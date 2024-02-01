import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/models/review_model.dart';
import 'package:restaurant_app/data/utils/app_constants.dart';

class ReviewService {
  static Future<Review> addReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse(AppConstants.addReview),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'name': name,
        'review': review,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return Review.fromJson(jsonData);
    } else {
      throw Exception('Failed to add review restaurant');
    }
  }
}
