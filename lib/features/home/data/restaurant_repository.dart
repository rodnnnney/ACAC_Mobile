import 'package:ACAC/features/home/service/restaurant_api_service.dart';
import 'package:ACAC/models/Restaurant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final restaurantAPIService = ref.read(restaurantAPIServiceProvider);
  return RestaurantRepository(restaurantAPIService);
});

class RestaurantRepository {
  RestaurantRepository(this.restaurantAPIService);

  final RestaurantAPIService restaurantAPIService;

  Future<List<Restaurant>> getRestaurants() {
    return restaurantAPIService.getRestaurants();
  }

  Future<void> add(Restaurant restaurant) async {
    return restaurantAPIService.addRestaurant(restaurant);
  }

  Future<void> delete(Restaurant deletedRestaurant) async {
    return restaurantAPIService.deleteRestaurant(deletedRestaurant);
  }
}
