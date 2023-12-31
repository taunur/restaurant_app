import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/utils/app_constants.dart';
import 'dart:convert';

import 'restaurant_services_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late RestaurantServices restaurantServices;

  setUp(() {
    mockClient = MockClient();
    restaurantServices = RestaurantServices(mockClient);
  });

  /// Search restaurant
  test('should return search results with success when status code is 200',
      () async {
    // arrange
    const query = 'melting';
    final searchUri = Uri.parse(AppConstants.searchUri + query);
    const searchJsonString = '''
    {
      "error": false,
      "founded": 1,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        }
      ]
    }
  ''';
    when(mockClient.get(searchUri))
        .thenAnswer((_) async => http.Response(searchJsonString, 200));

    // act
    final result = await restaurantServices.getSearch(query);

    // assert
    final expectedSearchResult = SearchResult(
      error: false,
      founded: 1,
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum...',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2,
        )
      ],
    );

    final expectedJson = json.encode(expectedSearchResult.toJson());
    final actualJson = json.encode(result.toJson());
    expect(actualJson, equals(expectedJson));

    verify(mockClient.get(searchUri));
  });

  test('should throw an exception when status code is not 200 for search',
      () async {
    // arrange
    const query = 'melting';
    final searchUri = Uri.parse(AppConstants.searchUri + query);
    when(mockClient.get(searchUri))
        .thenAnswer((_) async => http.Response('', 404));

    // act
    final call = restaurantServices.getSearch(query);

    // assert
    expect(() => call, throwsA(isA<Exception>()));
    verify(mockClient.get(searchUri));
  });

  /// getRestaurant
  final uri = Uri.parse(AppConstants.getRestaurant);
  const jsonString = '''
    {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        }
      ]
    }
  ''';

  final restaurants = [
    Restaurant(
      id: 'rqdv5juczeskfw1e867',
      name: 'Melting Pot',
      description:
          'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.',
      pictureId: '14',
      city: 'Medan',
      rating: 4.2,
    )
  ];

  test(
    'should return a list of restaurant with success when status code is 200',
    () async {
      /// arrange
      when(mockClient.get(uri))
          .thenAnswer((_) async => http.Response(jsonString, 200));

      /// act
      final result = await restaurantServices.getAllRestaurants();

      /// assert
      final expectedJson =
          json.encode(restaurants.map((r) => r.toJson()).toList());
      final actualJson = json.encode(result.map((r) => r.toJson()).toList());
      expect(actualJson, equals(expectedJson));

      verify(mockClient.get(uri));
    },
  );

  test('should throw an exception when status code is not 200', () async {
    /// arrange
    when(mockClient.get(uri)).thenAnswer((_) async => http.Response('', 404));

    /// act
    final call = restaurantServices.getAllRestaurants();

    /// assert
    expect(() => call, throwsA(isA<Exception>()));
    verify(mockClient.get(uri));
  });
}
