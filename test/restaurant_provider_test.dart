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
    expect(listenCount, equals(1));
    verify(mockRestaurantServices.getAllRestaurants());
  });

  test('should change state into error', () async {
    // arrange
    when(mockConnectionServices.isInternetAvailable())
        .thenAnswer((_) async => true);
    when(mockRestaurantServices.getAllRestaurants()).thenThrow(Error());
    // act
    await restaurantProvider.getRestaurant();
    // assert
    expect(restaurantProvider.state, equals(ResultState.error));
    expect(listenCount, equals(1));
    verify(mockRestaurantServices.getAllRestaurants());
  });
}
