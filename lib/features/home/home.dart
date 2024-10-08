import 'dart:async';
import 'dart:math';

import 'package:ACAC/common/consts/globals.dart';
import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/routing/ui/app_bar.dart';
import 'package:ACAC/common/routing/ui/centerNavButton.dart';
import 'package:ACAC/common/services/cachedRestaurantProvider.dart';
import 'package:ACAC/common/services/getDistance.dart';
import 'package:ACAC/common/services/route_observer.dart';
import 'package:ACAC/common/widgets/restaurant_related_ui/home_page_card.dart';
import 'package:ACAC/common/widgets/ui/welcome_text.dart';
import 'package:ACAC/features/admin/admin_home.dart';
import 'package:ACAC/features/home/helper_widgets/card/home_page_user_card.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_country.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_food_type.dart';
import 'package:ACAC/features/home/helper_widgets/food_sort/sort_by_rating.dart';
import 'package:ACAC/features/user_auth/controller/user_repository.dart';
import 'package:ACAC/features/user_auth/data/cache_user.dart';
import 'package:ACAC/models/MarketingCard.dart';
import 'package:ACAC/models/RestaurantInfoCard.dart';
import 'package:ACAC/models/User.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'controller/marketing_card_controller.dart';
import 'history.dart';

// Home Page of the app
class HomePage extends ConsumerStatefulWidget {
  static String id = 'home_screen';

  @override
  _HomePageState createState() => _HomePageState();
}

LatLng userLocation = const LatLng(0, 0);
GetDistance getDistance = GetDistance();
final Map<String, String> distanceCache = {};
final gemini = Gemini.instance;

class _HomePageState extends ConsumerState<HomePage> with RouteAware {
  Future<void> _initializeLocation() async {
    try {
      userLocation = await location.find();
    } catch (e) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    ref.read(userPageCounter).setCounter(0);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantData = ref.watch(cachedRestaurantInfoCardListProvider);
    final marketingCardAsync = ref.watch(marketingCardControllerProvider);
    final itemsRepository = ref.read(userRepositoryProvider);
    final userObject = ref.watch(currentUserProvider);

    Future<User> getUserInfo() async {
      var userID = await Amplify.Auth.getCurrentUser();
      return await itemsRepository.getUser(userID.userId);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CenterNavWidget(
        ref: ref,
      ),
      body: restaurantData.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error:$stack')),
          data: (allInfoCards) {
            final restaurantsByTimesVisited =
                List<RestaurantInfoCard>.from(allInfoCards)
                  ..sort((a, b) => b.timesVisited.compareTo(a.timesVisited));
            return SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 5, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Welcome(),
                              FutureBuilder<User>(
                                  future: getUserInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    } else {
                                      bool show = (snapshot.data?.id ==
                                          dotenv.get('ADMIN_ID'));
                                      return show
                                          ? const AdminButton()
                                          : Container();
                                    }
                                  })
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Featured:",
                                      style: AppTheme.styling),
                                  GestureDetector(
                                    // onTap: () {
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => DiscountCard(
                                    //         firstName: 'Rimuru',
                                    //         lastName: 'Tempest',
                                    //         restaurantInfoCard:
                                    //             restaurantsByTimesVisited[0],
                                    //       ),
                                    //     ),
                                    //   );
                                    // },
                                    child: const Text("Items Found: 2",
                                        style: AppTheme.styling),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              marketingCardAsync.when(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stack) =>
                                    Center(child: Text('Error: $error')),
                                data: (marketingCard) {
                                  List<MarketingCard> cardList = marketingCard;
                                  return SizedBox(
                                    height: 240,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: PageView.builder(
                                      itemCount: cardList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CouponCard(
                                                  imageUrl:
                                                      cardList[index].imageUrl,
                                                  header: cardList[index]
                                                      .headerText,
                                                  description: cardList[index]
                                                      .descriptionText,
                                                );
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fitWidth,
                                              width: double.infinity,
                                              imageUrl:
                                                  cardList[index].imageUrl,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("ACAC Favourites:",
                                  style: AppTheme.styling),
                              //const GradientText(gradText: "ACAC Favourites:"),
                              userObject.when(
                                data: (user) {
                                  return SizedBox(
                                    height: 170,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: min(allInfoCards.length, 5),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const SizedBox(width: 10),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FutureBuilder(
                                          future: getUserInfo(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<User> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Opacity(
                                                opacity: 0.2,
                                                child: Container(
                                                  width: 200,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.grey),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text("${snapshot.error}");
                                            } else {
                                              return SizedBox(
                                                width: 200,
                                                child: HomePageUserCard(
                                                  restaurantInfoCard:
                                                      restaurantsByTimesVisited[
                                                          index],
                                                  user: userLocation,
                                                  index: index,
                                                  ref: ref,
                                                  favouriteList: snapshot.data
                                                          ?.favouriteRestaurants ??
                                                      [],
                                                  parentSetState: () =>
                                                      setState(() {}),
                                                  currentUser: user,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                error: (Object error, StackTrace stackTrace) {
                                  safePrint('An error occurred: $error');
                                  return Text('An error occurred: $error');
                                },
                                loading: () {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Country: ", style: AppTheme.styling),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sortByCountry.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return HomeCard(
                                      displayIMG:
                                          sortByCountry[index].displayIMG,
                                      text: sortByCountry[index].text,
                                      routeName: sortByCountry[index].routeName,
                                    );
                                  },
                                ),
                              ),
                              const Text("Food Type:", style: AppTheme.styling),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sortByFoodType.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return HomeCard(
                                        displayIMG:
                                            sortByFoodType[index].displayIMG,
                                        text: sortByFoodType[index].text,
                                        routeName:
                                            sortByFoodType[index].routeName);
                                  },
                                ),
                              ),
                              const Text('Sort by:', style: AppTheme.styling),
                              SizedBox(
                                height: 130,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    NoImgCard(
                                      text: 'Rating',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "RATING");
                                      },
                                      iconData: Icons.star,
                                    ),
                                    NoImgCard(
                                      text: 'Trending',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "VISIT");
                                      },
                                      iconData: Icons.trending_up,
                                    ),
                                    NoImgCard(
                                      text: 'Alpha',
                                      routeName: (BuildContext, String) {
                                        Navigator.pushNamed(
                                            context, SortedByRating.id,
                                            arguments: "ALPHA");
                                      },
                                      iconData: Icons.abc,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: AppBarBottom(
        id: HomePage.id,
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  const AdminButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AdminHome.id);
        },
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppTheme.kGreen2)),
        child: const Text(
          'Admin Console',
          style: TextStyle(color: Colors.white),
        ));
  }
}

class TopMenuButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback pathFunction;
  final String desc;

  const TopMenuButton(
      {super.key,
      required this.iconData,
      required this.pathFunction,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        pathFunction();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: AppTheme.kGreen2,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Text(
              desc,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 3),
            Icon(
              iconData,
              color: AppTheme.kWhite,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String imageUrl;
  final String header;
  final String description;

  const CouponCard({
    super.key,
    required this.imageUrl,
    required this.header,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.contain,
                          width: double.infinity,
                          imageUrl: imageUrl,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              header,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white),
                      child: const Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
