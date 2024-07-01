import 'package:ACAC/common_layer/widgets/star_builder.dart';
import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/time_formatter.dart';
import 'package:ACAC/presentation_layer/pages/maps.dart';
import 'package:ACAC/presentation_layer/state_management/provider/navigation_info_provider.dart';
import 'package:ACAC/presentation_layer/state_management/provider/polyline_info.dart';
import 'package:ACAC/presentation_layer/state_management/provider/restaurant_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:url_launcher/url_launcher.dart';

class RestaurantAdditionalInfo extends StatefulWidget {
  const RestaurantAdditionalInfo(
      {super.key, required this.restaurant, required this.distance});

  final restaurantCard restaurant;
  final String distance;

  @override
  State<RestaurantAdditionalInfo> createState() =>
      _RestaurantAdditionalInfoState();
}

class _RestaurantAdditionalInfoState extends State<RestaurantAdditionalInfo> {
  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  void makePhoneCall(String phoneNumber) async {
    String digitsOnly = phoneNumber.replaceAll(' ', '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: digitsOnly,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    PolyInfo maps = legacy_provider.Provider.of<PolyInfo>(context);
    NavInfo nav = legacy_provider.Provider.of<NavInfo>(context);
    RestaurantInfo data = legacy_provider.Provider.of<RestaurantInfo>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24, // Size of the icon
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.restaurant.imageSrc,
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.restaurantName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(widget.restaurant.address),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                    '${widget.restaurant.hours.getTodayStartStop().startTime} - ${widget.restaurant.hours.getTodayStartStop().endTime}'),
                                const SizedBox(width: 7),
                                FutureBuilder<Map<String, dynamic>>(
                                  future: getCurrentStatusWithColor(
                                      widget.restaurant.hours
                                          .getTodayStartStop()
                                          .startTime,
                                      widget.restaurant.hours
                                          .getTodayStartStop()
                                          .endTime),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      var status = snapshot.data?['status'] ??
                                          'Unknown status';
                                      var color = snapshot.data?['color'] ??
                                          Colors.black;
                                      return Text(
                                        status,
                                        style: TextStyle(color: color),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.restaurant.rating.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                buildStarRating(widget.restaurant.rating),
                                const SizedBox(
                                  width: 3,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                final url =
                                    Uri.parse(widget.restaurant.gMapsLink);
                                try {
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {}
                                } catch (e) {
                                  //print(e);
                                }
                              },
                              child: Text(
                                '${formatNumber(widget.restaurant.reviewNum)} + ratings',
                                style: const TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.distance,
                        ),
                        Text(widget.restaurant.cuisineType[0])
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              minRadius: 18,
                              maxRadius: 24,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.restaurant.imageLogo),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACAC Discount',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text('Valid until 12/12/2024')
                              ],
                            ),
                            Container(
                              width: 0.5,
                              height: 48,
                              color: Colors.black,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '10%',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffE68437)),
                                ),
                                Text(
                                  'OFF',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xffE68437),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text('Most Popular'),
                      ],
                    ),
                    widget.restaurant.topRatedItemsName.isEmpty
                        ? SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: const Text('Nothing Found')),
                                        const Text(
                                          'Nothing found',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    widget.restaurant.topRatedItemsName.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.restaurant
                                                          .topRatedItemsImgSrc[
                                                      index],
                                                  height: 120,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  widget.restaurant
                                                      .topRatedItemsName[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            '${index + 1}# Most Popular!',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(horizontal: 12)),
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.green),
                              foregroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () async {
                              if (context.mounted) {
                                Navigator.pushNamed(context, MapScreen.id);
                              }
                              try {
                                LatLng user = await data.getLocation();
                                String url = await maps.createHttpUrl(
                                  user.latitude,
                                  user.longitude,
                                  widget.restaurant.location.latitude,
                                  widget.restaurant.location.longitude,
                                );
                                maps.processPolylineData(url);
                                maps.updateCameraBounds(
                                    [user, widget.restaurant.location]);
                                nav.updateRouteDetails(url);
                              } catch (e) {
                                //  print(e);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Find on Map'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.location_on)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
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
                              makePhoneCall(widget.restaurant.phoneNumber);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Call'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.phone)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
