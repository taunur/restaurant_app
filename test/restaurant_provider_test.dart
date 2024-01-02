import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/connection_services.dart';
import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/utils/result_state.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([RestaurantServices, ConnectionServices])
void main() {
  late MockRestaurantServices mockRestaurantServices;
  late MockConnectionServices mockConnectionServices;
  late RestaurantProvider restaurantProvider;
  int listenCount = 0;

  setUp(() {
    listenCount = 0;
    mockRestaurantServices = MockRestaurantServices();
    mockConnectionServices = MockConnectionServices();
    restaurantProvider = RestaurantProvider(
      restaurantServices: mockRestaurantServices,
      connectionServices: mockConnectionServices,
    )..addListener(() {
        listenCount++;
      });
  });

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
      'should change state into success, and restaurants variable should be filled',
      () async {
    // arrange
    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getAllRestaurants())
        .thenAnswer((_) async => restaurants);
    // act
    await restaurantProvider.getRestaurant();
    // assert
    expect(restaurantProvider.state, equals(ResultState.hasData));
    expect(restaurantProvider.allRestaurants, equals(restaurants));
    expect(listenCount, equals(2));
    verify(mockRestaurantServices.getAllRestaurants());
  });

  test('empty data updates state to noData', () async {
    // arrange
    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getAllRestaurants())
        .thenAnswer((_) async => []);

    // act
    await restaurantProvider.getRestaurant();

    // assert
    expect(restaurantProvider.state, equals(ResultState.noData));
    expect(restaurantProvider.message, equals('Empty Data'));
    expect(listenCount, equals(2));
    verify(mockRestaurantServices.getAllRestaurants());
  });

  test('should change state into error', () async {
    // arrange
    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => false);
    when(mockRestaurantServices.getAllRestaurants()).thenThrow(Error());
    // act
    await restaurantProvider.getRestaurant();
    // assert
    expect(restaurantProvider.state, equals(ResultState.error));
    expect(listenCount, equals(3));
    verifyNever(mockRestaurantServices.getAllRestaurants());
    verifyNoMoreInteractions(mockRestaurantServices);
  });

  test('should change state to hasData when search result is not empty',
      () async {
    // arrange
    const query = 'Melting Pot';
    final searchResult = SearchResult(
      founded: 1,
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum...',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2,
        ),
      ],
      error: false,
    );

    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getSearch(query))
        .thenAnswer((_) async => searchResult);

    // act
    await restaurantProvider.search(query);

    // assert
    expect(restaurantProvider.state, equals(ResultState.hasData));
    expect(restaurantProvider.result, equals(searchResult));
    expect(listenCount, equals(2));
    verify(mockRestaurantServices.getSearch(query));
  });

  test('should change state to noData when search result is empty', () async {
    // arrange
    const query = 'Nonexistent Restaurant';
    final emptySearchResult =
        SearchResult(founded: 0, restaurants: [], error: true);

    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getSearch(query))
        .thenAnswer((_) async => emptySearchResult);

    // act
    await restaurantProvider.search(query);

    // assert
    expect(restaurantProvider.state, equals(ResultState.noData));
    expect(restaurantProvider.message,
        equals('No restaurant name found: "$query"'));
    expect(listenCount, equals(2));
    verify(mockRestaurantServices.getSearch(query));
  });

  test('should change state to error when search throws an exception',
      () async {
    // arrange
    const query = 'Melting Pot';

    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getSearch(query)).thenThrow(Error());

    // act
    await restaurantProvider.search(query);

    // assert
    expect(restaurantProvider.state, equals(ResultState.error));
    expect(restaurantProvider.message,
        equals('Failed to load restaurant check your connection'));
    expect(listenCount, equals(2));

    // verify the expected call
    verify(mockRestaurantServices.getSearch(query)).called(1);
    verifyNoMoreInteractions(
        mockRestaurantServices); // ensure no other unexpected calls
  });
}
