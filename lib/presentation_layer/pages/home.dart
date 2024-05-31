import 'package:flutter/material.dart';
import 'package:googlemaptest/common_layer/widgets/app_bar.dart';
import 'package:googlemaptest/common_layer/widgets/welcome_text.dart';
import 'package:googlemaptest/domain_layer/local_db/sort_by_country.dart';
import 'package:googlemaptest/domain_layer/local_db/sort_by_food_type.dart';
import 'package:googlemaptest/presentation_layer/widgets/home_page_card.dart';

class HomePage extends StatelessWidget {
  static String id = 'home_screen';

  String cutAndLowercase(String name) {
    int spaceIndex = name.indexOf(' ');
    if (spaceIndex == -1) {
      return name.toLowerCase();
    }
    return name.substring(0, spaceIndex).toLowerCase();
  }

  final List<String> images = [
    'images/china.webp',
    'images/tofu.webp',
    'images/japan.avif',
  ];

  @override
  Widget build(BuildContext context) {
    //final List<HomeCard> countrySort = ref.read(sortByCountry);

    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 30, right: 30, bottom: 5, top: screenHeight * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Welcome(),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(colors: [
                              Color(0xff14342B),
                              Color(0xff60935D),
                            ], stops: [
                              0.1,
                              0.9,
                            ]).createShader(bounds),
                            child: const Text(
                              'featured',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xff036D19),
                                Color(0xff7EA172),
                                Color(0xff60935D),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'items found: ${images.length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: screenHeight * 0.19,
                          child: PageView.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              })),
                      const SizedBox(
                        height: 20,
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(colors: [
                          Color(0xff14342B),
                          Color(0xff60935D),
                          Color(0xffF3F9D2),
                        ], stops: [
                          0.1,
                          0.9,
                          1
                        ]).createShader(bounds),
                        child: const Text(
                          'Country:',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.2,
                        // Set appropriate height for GridView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sortByCountry.length,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeCard(
                                displayIMG: sortByCountry[index].displayIMG,
                                text: sortByCountry[index].text,
                                routeName: sortByCountry[index].routeName);
                          },
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(colors: [
                          Color(0xff14342B),
                          Color(0xff60935D),
                          Color(0xffF3F9D2),
                        ], stops: [
                          0.1,
                          0.9,
                          1
                        ]).createShader(bounds),
                        child: const Text(
                          'Food Type:',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.2,
                        // Set appropriate height for GridView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sortByFoodType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeCard(
                                displayIMG: sortByCountry[index].displayIMG,
                                text: sortByFoodType[index].text,
                                routeName: sortByFoodType[index].routeName);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: AppBarBottom(
        id: id,
      ),
    );
  }
}
