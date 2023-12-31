import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/models/detail_resto_model.dart';
import 'package:restaurant_app/data/utils/app_constants.dart';

class DetailRestoService {
  static Future<DetailResto> fetchDetailResto(String id) async {
    final response = await http.get(Uri.parse(
      AppConstants.getDetail + id,
    ));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return DetailResto.fromJson(jsonData);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }
}
