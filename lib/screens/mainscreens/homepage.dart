import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/mainscreens/sell.dart';
import 'package:poultry_app/screens/mainscreens/todayrate.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';
import 'package:poultry_app/widgets/recommendationwidget.dart';
import 'package:poultry_app/widgets/searchbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List sell = [];
  List banners = [];
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    getCategory();
    getBannerImages();
  }

  void getCategory() async {
    await reference.child('Categories').once().then((value) {
      if (value.snapshot.value != null) {
        Map response = value.snapshot.value as Map;
        sell = response.values.toList();
        setState(() {});
      }
    });
  }

  void getBannerImages() async {
    await reference.child('Banner').once().then((value) {
      if (value.snapshot.value != null) {
        Map response = value.snapshot.value as Map;
        banners = response.values.toList();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Poultry Hub",
                        style: bodyText16w600(color: black),
                      ),
                      TextButton(
                        onPressed: () {
                          NextScreen(context, const TodayRatePage());
                        },
                        child: Text(
                          "Today's Rate",
                          style: bodyText12w600(color: yellow),
                        ),
                      ),
                      CustomButton(
                        radius: 6,
                        text: "Sell",
                        onClick: () {
                          NextScreen(context, const HomepageSell());
                        },
                        width: 78,
                        height: 30,
                        textStyle: bodyText16w600(color: white),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: "Coming Soon!");
                    },
                    child: const CustomSearchBox(
                      isEnabled: false,
                    ),
                  ),
                  addVerticalSpace(10),
                  SizedBox(
                    height: 200,
                    width: width(context),
                    child: banners.isNotEmpty
                        ? PageView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: banners[index]['image'],
                                placeholder: (context, url) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: const Text('Loading...'),
                                  );
                                },
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: const Text('Loading...'),
                          ),
                  ),
                  addVerticalSpace(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Category",
                        style: bodyText14w600(color: black),
                      ),
                      Text(
                        'See More',
                        style: TextStyle(
                          color: yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 165,
                    child: sell.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 30),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: sell.length >= 4 ? 4 : sell.length,
                              itemBuilder: (context, index) {
                                return popularCategory(
                                  context,
                                  sell[index]['image'],
                                  sell[index]['name'],
                                  width(context) * .2,
                                  width(context) * .2,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 10,
                                );
                              },
                            ),
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     popularCategory(
                            //       context,
                            //       "assets/images/birds.png",
                            //       "Birds",
                            //       width(context) * .2,
                            //       width(context) * .2,
                            //     ),
                            //     popularCategory(
                            //       context,
                            //       "assets/images/eggs.png",
                            //       "Eggs",
                            //       width(context) * .2,
                            //       width(context) * .2,
                            //     ),
                            //     popularCategory(
                            //       context,
                            //       "assets/images/chick.png",
                            //       "Chicks",
                            //       width(context) * .2,
                            //       width(context) * .2,
                            //     ),
                            //     popularCategory(
                            //       context,
                            //       "assets/images/duck.png",
                            //       "Ducks",
                            //       width(context) * .2,
                            //       width(context) * .2,
                            //     ),
                            //   ],
                            // ),
                          )
                        : null,
                  ),
                  Text(
                    "Advertisements",
                    style: bodyText14w600(color: black),
                  ),
                ],
              ),
            ),
            const RecommendationWidget(),
          ],
        ),
      ),
    );
  }
}
