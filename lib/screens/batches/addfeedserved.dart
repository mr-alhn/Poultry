import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddFeedServedPage extends StatefulWidget {
  String docId;
  String owner;
  AddFeedServedPage({super.key, required this.docId, required this.owner});

  @override
  State<AddFeedServedPage> createState() => _AddFeedServedPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddFeedServedPageState extends State<AddFeedServedPage> {
  final _formKey = GlobalKey<FormState>();

  final fireStore = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection("Batches")
      .doc(user)
      .collection("AddFeedServed");

  double stockForType = 0.0;
  String feedSelected = "";
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final feedTypeController = TextEditingController();
  final totalFeedController = TextEditingController();

  List feedType = [];
  Map stockAvailable = {};
  Map prices = {};
  double priceFeed = 0.0;
  int netChicks = 0;

  Future<void> getBatchInformation() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) {
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
        netChicks = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
      });
    });
  }

  Future<void> getFeedType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('settings')
        .doc('Feed Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedType = value.data()?['feedType'];
        });
      }
    });
  }

  Future<void> getStockAvailable(String feed) async {
    setState(() {
      prices.clear();
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) async {
      if (value.exists) {
        Map feedTypeMap = value.data()?["feedTypeQuantity"]?[feed] ?? {};
        double bagWeight = 0;
        for (var key in feedTypeMap.keys.toList()..sort()) {
          if (key != "used") {
            if (feedTypeMap[key] > 0) {
              int bagQuantity = int.parse(
                  value.data()!["feedTypeQuantity"][feed][key].toString());
              await FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.owner)
                  .get()
                  .then((orderValue) {
                print(orderValue.data());
                setState(() {
                  bagWeight = double.parse(
                      orderValue.data()![key]["feedWeight"].toString());
                  stockAvailable[key] = bagWeight;
                  prices[key] = double.parse(
                      orderValue.data()![key]["feedPrice"].toString());
                });
              });
              setState(() {
                stockForType += bagWeight * bagQuantity;
              });
            }
          } else {
            //used
            Map usedMap = value.data()?["feedTypeQuantity"][feed]["used"] ?? {};
            for (var keys in usedMap.keys.toList()..sort()) {
              double usedQuantity = double.parse(value
                      .data()!["feedTypeQuantity"][feed]["used"][keys]
                      .toString()) *
                  50;
              setState(() {
                stockForType -= usedQuantity;
              });
            }
          }
        }
      }
    });
    print(prices);
  }

  @override
  void initState() {
    super.initState();
    getFeedType();
    getBatchInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(20),
                        Center(
                          child: Text(
                            "Add Feed Served",
                            style: bodyText22w600(color: black),
                          ),
                        ),
                        addVerticalSpace(20),
                        CustomTextField(
                            hintText: "Date",
                            suffix: true,
                            controller: dateController,
                            cannotSelectBefore: batchDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Date';
                              }
                              return null;
                            }),
                        CustomDropdown(
                          list: feedType,
                          height: 58,
                          hint: "Feed Type",
                          onchanged: (value) {
                            setState(() {
                              feedSelected = value;
                              stockForType = 0;
                            });
                            getStockAvailable(value);
                          },
                        ),
                        CustomTextField(
                          hintText:
                              "Available in KG: ${stockForType.toStringAsFixed(2)}",
                          enabled: false,
                        ),
                        CustomTextField(
                            hintText: "Total Feed given in KG",
                            controller: totalFeedController,
                            textType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Total Feed';
                              }
                              return null;
                            })
                      ]),
                ),
              ),
            ]),
            addVerticalSpace(height(context) * .35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomButton(
                  text: "Add",
                  onClick: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              contentPadding: const EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              content: Builder(builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;

                                return Container(
                                  height: height * 0.2,
                                  padding: const EdgeInsets.all(
                                    10.0,
                                  ),
                                  child: Column(
                                    children: [
                                      // SizedBox(
                                      //   height: 20.0,
                                      // ),
                                      Center(
                                        child: Text(
                                          "This action is not reversible. Are you sure you want to continue with Date: ${dateController.text.toString()}?",
                                          textAlign: TextAlign.center,
                                          style: bodyText16Bold(
                                            color: black,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                  border:
                                                      Border.all(color: yellow),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Center(
                                                child: Text(
                                                  'Cancel',
                                                  style: bodyText14Bold(
                                                      color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          addHorizontalySpace(20),
                                          InkWell(
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Processing Data')),
                                                );
                                                double priceForFeed = 0.0;
                                                double totalFeedUsed =
                                                    double.parse(
                                                        totalFeedController.text
                                                            .toString());
                                                if (totalFeedUsed >
                                                    stockForType) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Stock not available!");
                                                } else {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.owner)
                                                      .collection("Batches")
                                                      .doc(widget.docId)
                                                      .get()
                                                      .then((value) async {
                                                    Map feedMap = value.data()![
                                                                "feedTypeQuantity"]
                                                            [feedSelected] ??
                                                        {};

                                                    Map usedMap = value.data()![
                                                                    "feedTypeQuantity"]
                                                                [feedSelected]
                                                            ["used"] ??
                                                        {};

                                                    double bagsUsed = double
                                                        .parse((totalFeedUsed /
                                                                50)
                                                            .toStringAsPrecision(
                                                                2));

                                                    for (var keys
                                                        in feedMap.keys.toList()
                                                          ..sort()) {
                                                      double currentLeft = 0.0;
                                                      if (usedMap[keys] ==
                                                          null) {
                                                        currentLeft = double
                                                                .tryParse(feedMap[
                                                                        keys]
                                                                    .toString()) ??
                                                            -1;
                                                      } else {
                                                        currentLeft = double
                                                                .parse(feedMap[
                                                                        keys]
                                                                    .toString()) -
                                                            double.parse(
                                                                usedMap[keys]
                                                                    .toString());
                                                      }

                                                      //49.6 bags left
                                                      //0.6 bags used < 49.6 bags left
                                                      if (bagsUsed > 0) {
                                                        if (currentLeft == -1) {
                                                          break;
                                                        }
                                                        if (bagsUsed <
                                                            currentLeft) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget.owner)
                                                              .collection(
                                                                  "Batches")
                                                              .doc(widget.docId)
                                                              .set(
                                                                  {
                                                                "feedTypeQuantity":
                                                                    {
                                                                  feedSelected:
                                                                      {
                                                                    "used": {
                                                                      keys: FieldValue
                                                                          .increment(
                                                                              double.parse(bagsUsed.toStringAsFixed(2))),
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));
                                                          priceFeed +=
                                                              prices[keys] *
                                                                  bagsUsed;
                                                          break;
                                                        } else {
                                                          // 2 bags used > 0.6 bags left
                                                          if (currentLeft ==
                                                              -1) {
                                                            break;
                                                          }
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget.owner)
                                                              .collection(
                                                                  "Batches")
                                                              .doc(widget.docId)
                                                              .set(
                                                                  {
                                                                "feedTypeQuantity":
                                                                    {
                                                                  feedSelected:
                                                                      {
                                                                    "used": {
                                                                      keys: FieldValue
                                                                          .increment(
                                                                              double.parse(currentLeft.toStringAsFixed(2))),
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                                  SetOptions(
                                                                      merge:
                                                                          true));

                                                          priceFeed +=
                                                              prices[keys] *
                                                                  currentLeft;

                                                          setState(() {
                                                            bagsUsed -=
                                                                currentLeft;
                                                            if (currentLeft ==
                                                                -1) {
                                                              setState(() {
                                                                bagsUsed = 0;
                                                              });
                                                            }
                                                          });
                                                        }
                                                      }
                                                    }
                                                  });

                                                  print(priceFeed);

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(widget.owner)
                                                      .collection("Batches")
                                                      .doc(widget.docId)
                                                      .collection("BatchData")
                                                      .doc("Feed Served")
                                                      .set({
                                                    "feedServed":
                                                        FieldValue.arrayUnion([
                                                      {
                                                        "date": dateController
                                                            .text
                                                            .toString(),
                                                        "feedType":
                                                            feedSelected,
                                                        "feedQuantity":
                                                            double.parse(
                                                                totalFeedController
                                                                    .text
                                                                    .toString()),
                                                        "priceForFeed":
                                                            priceFeed,
                                                        "liveChicksThen":
                                                            netChicks,
                                                      }
                                                    ]),
                                                  }, SetOptions(merge: true));

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget.owner)
                                                      .collection("Batches")
                                                      .doc(widget.docId)
                                                      .collection("BatchData")
                                                      .doc("Expenses")
                                                      .set({
                                                    "expenseDetails":
                                                        FieldValue.arrayUnion([
                                                      {
                                                        "Amount": priceFeed,
                                                        "Description":
                                                            "Served as Feed",
                                                        "Expenses Category":
                                                            "Feed Served",
                                                        "Date": dateController
                                                            .text
                                                            .toString(),
                                                        "NoOfChicksThen":
                                                            netChicks,
                                                      }
                                                    ]),
                                                  }, SetOptions(merge: true));

                                                  Navigator.pop(context, true);
                                                  Navigator.pop(context, true);
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: width * 0.25,
                                              decoration: BoxDecoration(
                                                  border:
                                                      Border.all(color: yellow),
                                                  color: yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Center(
                                                child: Text(
                                                  'Continue',
                                                  style: bodyText14Bold(
                                                      color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }));
                        });
                  },
                  width: width(context),
                  height: 55),
            )
          ],
        ),
      ),
    );
  }
}
