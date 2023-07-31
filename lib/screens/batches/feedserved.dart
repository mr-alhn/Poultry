import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addfeedserved.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class FeedServedPage extends StatefulWidget {
  String docId;
  int accessLevel;
  String owner;
  FeedServedPage(
      {super.key,
      required this.docId,
      required this.accessLevel,
      required this.owner});

  @override
  State<FeedServedPage> createState() => _FeedServedPageState();
}

class _FeedServedPageState extends State<FeedServedPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];

  List feedServed = [];
  int noBirds = 0;
  String breed = "";
  bool isLoading = true;
  double requirement = 0.0;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchDetails() async {
    setState(() {
      isLoading = true;
      feedServed.clear();
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) {
      print(value.data());
      setState(() {
        breed = value.data()!["Breed"].toString();
        noBirds = (int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString()));
      });
      List date = value.data()!["date"].toString().split("/");
      int month = 0;
      int day = int.parse(date[0]);
      switch (date[1]) {
        case "jan":
          month = 1;
          break;
        case "feb":
          month = 2;
          break;
        case "mar":
          month = 3;
          break;
        case "apr":
          month = 4;
          break;
        case "may":
          month = 5;
          break;
        case "jun":
          month = 6;
          break;
        case "jul":
          month = 7;
          break;
        case "aug":
          month = 8;
          break;
        case "sep":
          month = 9;
          break;
        case "oct":
          month = 10;
          break;
        case "nov":
          month = 11;
          break;
        case "dec":
          month = 12;
          break;
      }
      int year = int.parse(date[2]);
      //get individual dates!
      setState(() {
        batchDate = DateTime.utc(year, month, day);
        print(batchDate);
      });
      print("Type: $breed");
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          List date =
              value.data()!["feedServed"][i]["date"].toString().split("/");
          int month = 0;
          int day = int.parse(date[0]);
          switch (date[1]) {
            case "jan":
              month = 1;
              break;
            case "feb":
              month = 2;
              break;
            case "mar":
              month = 3;
              break;
            case "apr":
              month = 4;
              break;
            case "may":
              month = 5;
              break;
            case "jun":
              month = 6;
              break;
            case "jul":
              month = 7;
              break;
            case "aug":
              month = 8;
              break;
            case "sep":
              month = 9;
              break;
            case "oct":
              month = 10;
              break;
            case "nov":
              month = 11;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(date[2]);
          DateTime feedDate = DateTime.utc(year, month, day);

          print(feedDate);
          // print(batchDate);

          feedServed.add({
            "date": DateFormat("dd/MM/yyyy").format(feedDate),
            "day": feedDate.difference(batchDate).inDays + 1,
            "feedType": value.data()!["feedServed"][i]["feedType"],
            "feedServed": value.data()!["feedServed"][i]["feedQuantity"],
          });
        }

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          feedServed.sort((first, second) => (inputFormat.parse(first["date"]))
              .compareTo((inputFormat.parse(second["date"]))));
        });
      }
    });

    getTodayFeedRequirement();

    setState(() {
      isLoading = false;
    });

    print(feedServed);
  }

  @override
  void initState() {
    super.initState();
    getBatchDetails();

    // Fluttertoast.showToast(
    //     msg: "Feed served will be entered in Expenses automatically!");
  }

  Future<void> getTodayFeedRequirement() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Chick Feed Requirement")
        .get()
        .then((value) {
      if (value.exists) {
        int day = DateTime.utc(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .difference(batchDate)
                .inDays +
            1;
        double requirementInGrams = 0.0;
        if (value.data()![breed] != null) {
          for (int i = 0; i < value.data()![breed].length; i++) {
            if (int.parse(value.data()![breed][i]["day"].toString()) == day) {
              requirementInGrams +=
                  double.parse(value.data()![breed][i]["grams"].toString());
            }
          }

          setState(() {
            requirement = (requirementInGrams * noBirds) / 1000;
          });
        } else {
          Fluttertoast.showToast(
              msg: "Data for the particulars doesn't exist!");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddFeedServedPage(
                            docId: widget.docId,
                            owner: widget.owner,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getBatchDetails();
                  }
                }
              });
            })
          : null,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Batch",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Feed Served",
                    style: bodyText22w600(color: black),
                  ),
                  Row(
                    children: [
                      // Spacer(),
                      // // addHorizontalySpace(15),
                      Expanded(
                          child: CustomButton(
                              bcolor: darkGray,
                              buttonColor: white,
                              textStyle: bodyText12w600(color: darkGray),
                              text: "Today's Feed Requirement: $requirement kg",
                              onClick: () {},
                              width: width(context),
                              height: 30)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat("dd/MM/yyyy").format(DateTime.utc(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day)) ==
                                          feedServed[index]["date"]
                                      ? "${feedServed[index]["date"]} -- "
                                      : "${feedServed[index]["date"]}",
                                  style: bodyText12normal(color: darkGray),
                                ),
                                DateFormat("dd/MM/yyyy").format(DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)) ==
                                        feedServed[index]["date"]
                                    ? Text(
                                        "Today",
                                        style: bodyText12normal(color: yellow),
                                      )
                                    : Container(),
                              ],
                            ),
                            Text(
                              "Feed Served: ${feedServed[index]["feedServed"]} KG",
                              style: bodyText14normal(color: darkGray),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Day ${feedServed[index]["day"]}",
                              style: bodyText17w500(color: black),
                            ),
                            Text(
                              "${feedServed[index]["feedType"]}",
                              style: bodyText14normal(color: darkGray),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemCount: feedServed.length),
            const Divider(
              height: 0,
            ),
            addVerticalSpace(20),
            SizedBox(
              width: width(context) * 0.85,
              child: Center(
                child: Text(
                  "Feed served will be added to expenses automatically!",
                  style: bodyText14w500(color: darkGray),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
