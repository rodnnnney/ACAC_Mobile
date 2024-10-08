import 'dart:async';
import 'dart:convert';

import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/services/restaurant_provider.dart';
import 'package:ACAC/common/widgets/helper_functions/location.dart';
import 'package:ACAC/common/widgets/helper_functions/phone_call.dart';
import 'package:ACAC/common/widgets/helper_functions/time_formatter.dart';
import 'package:ACAC/features/home/helper_widgets/card/additional_data_dbb.dart';
import 'package:ACAC/features/home/home.dart';
import 'package:ACAC/features/maps/helper_widgets/swipe_up_card.dart';
import 'package:ACAC/features/maps/maps.dart';
import 'package:ACAC/features/maps/service/navigation_info_provider.dart';
import 'package:ACAC/features/maps/service/polyline_info.dart';
import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/features/user_auth/data/user_list_controller.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class DbbSort extends ConsumerStatefulWidget {
  static const String id = 'card_viewer';

  late final String cuisineType;

  DbbSort({super.key, required this.cuisineType});

  @override
  ConsumerState<DbbSort> createState() => DbbSortState();
}

class DbbSortState extends ConsumerState<DbbSort> {
  LatLng userPosition = const LatLng(0, 0);
  UserLocation location = UserLocation();
  LaunchLink phoneCall = LaunchLink();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    LatLng newPosition = await location.find();
    setState(() {
      userPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    var restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);

    return Scaffold(
      body: SafeArea(
        child: restaurantData.when(
          data: (allInfoCards) {
            List<RestaurantInfoCard> filteredRestaurants = allInfoCards
                .where((card) => card.cuisineType.contains(widget.cuisineType))
                .toList();
            return buildList(filteredRestaurants, DateTime.now().weekday);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.id);
                  },
                  child: const Text('Go back'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(List<RestaurantInfoCard> filteredRestaurants, int weekday) {
    PolyInfo maps = provider.Provider.of<PolyInfo>(context);
    RestaurantInfo data = provider.Provider.of<RestaurantInfo>(context);
    NavInfo nav = provider.Provider.of<NavInfo>(context);
    final watchCounter = ref.watch(userPageCounter);
    final itemsRepository = ref.read(userRepositoryProvider);

    void updatePage(int index, String route) {
      Navigator.pushNamed(context, route);
      ref.read(userPageCounter).setCounter(index);
    }

    Future<User> getUserInfo() async {
      var userID = await Amplify.Auth.getCurrentUser();
      return await itemsRepository.getUser(userID.userId);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.cuisineType),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: filteredRestaurants.length == 1
                  ? Text('${filteredRestaurants.length.toString()} item found')
                  : Text(
                      '${filteredRestaurants.length.toString()} items found')),
        ],
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: filteredRestaurants.length,
        itemBuilder: (BuildContext context, int index) {
          Future<String> getDistance() async {
            String url = await maps.createHttpUrl(
                userPosition.latitude,
                userPosition.longitude,
                double.parse(filteredRestaurants[index].location.latitude),
                double.parse(filteredRestaurants[index].location.longitude));
            var decodedJson = jsonDecode(url);
            String distance =
                decodedJson['routes'][0]['legs'][0]['distance']['text'];
            return distance;
          }

          return Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            margin: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () async {
                String distance = await getDistance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdditionalDataDbb(
                      restaurant: filteredRestaurants[index],
                      distance: distance,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.white,
                elevation: 1,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: filteredRestaurants[index].imageSrc,
                            width: double.infinity,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        FutureBuilder<User>(
                          future: getUserInfo(),
                          builder: (BuildContext context,
                              AsyncSnapshot<User> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else if (snapshot.hasData) {
                              bool isFavourite = snapshot
                                  .data!.favouriteRestaurants
                                  .contains(filteredRestaurants[index]
                                      .restaurantName);
                              return Positioned(
                                right: 10,
                                top: 10,
                                child: GestureDetector(
                                    onTap: () async {
                                      if (isFavourite) {
                                        await ref
                                            .read(userListControllerProvider
                                                .notifier)
                                            .removeFromFavourite(
                                                filteredRestaurants[index]
                                                    .restaurantName);
                                      } else {
                                        await ref
                                            .read(userListControllerProvider
                                                .notifier)
                                            .addToFavourite(
                                                filteredRestaurants[index]
                                                    .restaurantName);
                                      }
                                      setState(() {});
                                    },
                                    child: FavouriteIcon(
                                      isFavourite: isFavourite,
                                    )),
                              );
                            } else {
                              return const Text('Something went wrong');
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filteredRestaurants[index].restaurantName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              FutureBuilder(
                                future: getDistance(),
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      const Icon(Icons.location_on),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(snapshot.data ?? ''),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(filteredRestaurants[index].address),
                          Row(
                            children: [
                              Text(
                                getHour(filteredRestaurants[index], weekday),
                                style: TextStyle(
                                  color: timeColor(
                                    DateTime.now(),
                                    splitHour(getHour(
                                        filteredRestaurants[index],
                                        weekday))[0], // Opening time
                                    splitHour(getHour(
                                        filteredRestaurants[index],
                                        weekday))[1], // Closing time
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 13, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.green),
                                foregroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.white),
                              ),
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                try {
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, MapScreen.id);
                                  }
                                  if (watchCounter.counter == 2) {
                                  } else {
                                    updatePage(2, MapScreen.id);
                                  }
                                  LatLng user = await data.getLocation();
                                  String url = await maps.createHttpUrl(
                                      user.latitude,
                                      user.longitude,
                                      double.parse(filteredRestaurants[index]
                                          .location
                                          .latitude),
                                      double.parse(filteredRestaurants[index]
                                          .location
                                          .longitude));

                                  maps.processPolylineData(url);
                                  maps.updateCameraBounds([
                                    user,
                                    filteredRestaurants[index].location
                                        as LatLng
                                  ]);
                                  nav.updateRouteDetails(url);
                                } catch (e) {}
                              },
                              child: const Text('Find on Map'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 12)),
                                backgroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.black),
                                foregroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.white),
                              ),
                              onPressed: () async {
                                phoneCall.makePhoneCall(
                                    filteredRestaurants[index].phoneNumber);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Reserve'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.phone)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8E8E8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    filteredRestaurants[index]
                                        .rating
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
