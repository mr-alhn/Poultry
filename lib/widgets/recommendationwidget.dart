import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/myads.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/navigation.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({super.key});

  @override
  RecommendationWidgetState createState() => RecommendationWidgetState();
}

class RecommendationWidgetState extends State<RecommendationWidget> {
  List availableAds = [];
  bool isLoading = true;

  Future<void> getAvailableAds() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection("ads").get().then((value) {
      // print(value.docs[0].data().toString());
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].id != FirebaseAuth.instance.currentUser!.uid) {
          print(value.docs[i].data());
          for (int j = 0;
              j < value.docs[i].data()["advertisementDetails"].length;
              j++) {
            if (value.docs[i].data()["advertisementDetails"][j]["sold"] !=
                true) {
              setState(() {
                availableAds.add({
                  "city": value.docs[i].data()["advertisementDetails"][j]
                      ["city"],
                  "contact": value.docs[i].data()["advertisementDetails"][j]
                      ["contact"],
                  "date": value.docs[i].data()["advertisementDetails"][j]
                      ["date"],
                  "village": value.docs[i].data()["advertisementDetails"][j]
                      ["village"],
                  "imageUrl": value.docs[i].data()["advertisementDetails"][j]
                          ["imageUrl"] ??
                      "",
                  "description": value.docs[i].data()["advertisementDetails"][j]
                      ["description"],
                  "type": value.docs[i].data()["advertisementDetails"][j]
                      ["type"],
                  "state": value.docs[i].data()["advertisementDetails"][j]
                      ["state"],
                  "quantity": value.docs[i]
                      .data()["advertisementDetails"][j]["quantity"]
                      .toString(),
                });
              });
            }
          }
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAvailableAds();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : availableAds.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Center(
                  child: Text(
                    "No Ads available!",
                    style: bodyText14w500(color: black),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: availableAds.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: width(context) * .43 / 163,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      NextScreen(
                          context,
                          MyAdsPage(
                            type: availableAds[index]["type"],
                            imageUrl: availableAds[index]["imageUrl"],
                            description: availableAds[index]["description"],
                            quantity: availableAds[index]["quantity"],
                            contact: availableAds[index]["contact"],
                            state: availableAds[index]["state"],
                            city: availableAds[index]["city"],
                            village: availableAds[index]["village"],
                            datePosted: availableAds[index]["date"],
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: shadowDecoration(10, 0, normalGray),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                            child: availableAds[index]["imageUrl"] == ""
                                ? SizedBox(
                                    height: 85,
                                    width: width(context) * .4,
                                    child: const Center(
                                      child: Text("No Image"),
                                    ),
                                  )
                                : Image.network(
                                    availableAds[index]["imageUrl"],
                                    height: 85,
                                    width: width(context) * .4,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          SizedBox(
                            width: width(context) * .4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addVerticalSpace(10),
                                Text(
                                  availableAds[index]["type"],
                                  style: bodyText12w600(color: black),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  availableAds[index]["quantity"],
                                  style: bodyText10normal(color: gray),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      availableAds[index]["city"],
                                      style: bodyText10normal(color: gray),
                                    ),
                                    // Image.asset(
                                    //   "assets/images/call.png",
                                    //   height: 20,
                                    // )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
  }
}
