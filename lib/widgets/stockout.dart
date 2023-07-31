import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/quantitybutton.dart';

class StockOutWidget extends StatefulWidget {
  const StockOutWidget({super.key});

  @override
  State<StockOutWidget> createState() => _StockOutWidgetState();
}

List feedType = [];

class _StockOutWidgetState extends State<StockOutWidget> {
  List<String> batch = [];
  int stockForType = 0;

  List<String> batchDocIds = [];

  Future<void> getFeedType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
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

  Future<void> getBatches() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Batches')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (doc.data()["active"] == true) {
          setState(() {
            batch.add(doc.data()["BatchName"]);
            batchDocIds.add(doc.id);
          });
        }
      }
    });
  }

  Future<void> getStockFromDB(String feedType, String batchName) async {
    setState(() {
      stockForType = 0;
    });
    await FirebaseFirestore.instance
        .collection('inventory')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!.length; i++) {
          if (value.data()?["order${i + 1}"]["feedType"] == feedType) {
            setState(() {
              stockForType += int.parse(
                  value.data()!["order${i + 1}"]["feedQuantity"].toString());
            });
          }
          
        }
      } else {
        print('No stock!');
        setState(() {
          stockForType = 0;
        });
        Fluttertoast.showToast(msg: "No stock in inventory!");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFeedType();
    getBatches();
  }

  String feed = "";
  String batchName = "";

  @override
  Widget build(BuildContext context) {
    QuantityButton quantityButton = QuantityButton(
      totalQuantity: stockForType,
      current: 0,
      canIncrease: true,
    );
    return SizedBox(
      height: height(context) - 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 55,
                  width: width(context),
                  decoration: shadowDecoration(
                    10,
                    0,
                    tfColor,
                    bcolor: normalGray,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: height(context) * 0.04,
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton(
                                icon: Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 18,
                                  color: gray,
                                ),
                                hint: Text(
                                  feed.isNotEmpty ? feed : "Feed Type",
                                  style: bodyText16normal(color: darkGray),
                                ),
                                style: bodyText15normal(color: black),
                                dropdownColor: white,
                                underline: const SizedBox(),
                                isExpanded: true,
                                items: feedType.map((e) {
                                  return DropdownMenuItem(
                                      value: e.toString(),
                                      child: Text(e.toString()));
                                }).toList(),
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    feed = value!;
                                  });
                                  if (batchName.isNotEmpty && feed.isNotEmpty) {
                                    getStockFromDB(feed, batchName);
                                  }

                                  // print(widget.value);
                                  // print(widget.value);
                                }),
                          ),
                        ],
                      ),
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 55,
                  width: width(context),
                  decoration: shadowDecoration(
                    10,
                    0,
                    tfColor,
                    bcolor: normalGray,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: height(context) * 0.04,
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton(
                                icon: Icon(
                                  CupertinoIcons.chevron_down,
                                  size: 18,
                                  color: gray,
                                ),
                                hint: Text(
                                  batchName.isNotEmpty
                                      ? batchName
                                      : "Transfer to Batch",
                                  style: bodyText16normal(color: darkGray),
                                ),
                                style: bodyText15normal(color: black),
                                dropdownColor: white,
                                underline: const SizedBox(),
                                isExpanded: true,
                                items: batch.map((e) {
                                  return DropdownMenuItem(
                                      value: e.toString(),
                                      child: Text(e.toString()));
                                }).toList(),
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    batchName = value!;
                                  });
                                  if (batchName.isNotEmpty && feed.isNotEmpty) {
                                    getStockFromDB(feed, batchName);
                                  }

                                  // print(widget.value);
                                  // print(widget.value);
                                }),
                          ),
                        ],
                      ),
                    ),
                  )),
              CustomTextField(
                hintText: "Quantity: $stockForType",
                enabled: false,
              ),
              quantityButton,
            ],
          ),
          CustomButton(
            text: "Transfer Feed",
            onClick: () async {
              if (quantityButton.current == 0) {
                Fluttertoast.showToast(msg: "Cannot transfer 0 quantity!");
              } else {
                int index = batch.indexOf(batchName);
                print(index);
                int stockToAdd = 0;
                await FirebaseFirestore.instance
                    .collection('inventory')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) async {
                  for (int i = 0; i < value.data()!.length; i++) {
                    if (quantityButton.current > 0 &&
                        value.data()!["order${i + 1}"]["feedType"] == feed) {
                      int existingStock =
                          value.data()!["order${i + 1}"]["feedQuantity"];
                      if (existingStock > 0) {
                        int quantityCurrent = quantityButton.current;
                        if (existingStock >= quantityCurrent) {
                          await FirebaseFirestore.instance
                              .collection('inventory')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(
                            {
                              "order${i + 1}": {
                                "feedQuantity": existingStock - quantityCurrent,
                              },
                            },
                            SetOptions(merge: true),
                          );
                          setState(() {
                            // stockForType = 0;
                            quantityButton.current = 0;
                            stockForType = quantityCurrent;
                            stockToAdd = quantityCurrent;
                          });

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Batches')
                              .doc(batchDocIds[index])
                              .set(
                            {
                              "feedTypeQuantity": {
                                feed: {
                                  "order${i + 1}":
                                      FieldValue.increment(stockToAdd),
                                },
                              },
                            },
                            SetOptions(
                              merge: true,
                            ),
                          );
                          break;
                        } else {
                          await FirebaseFirestore.instance
                              .collection('inventory')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(
                            {
                              "order${i + 1}": {
                                "feedQuantity": 0,
                              },
                            },
                            SetOptions(merge: true),
                          );
                          setState(() {
                            stockForType += existingStock;
                            stockToAdd = existingStock;
                            quantityButton.current -= existingStock;
                          });

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('Batches')
                              .doc(batchDocIds[index])
                              .set(
                            {
                              "feedTypeQuantity": {
                                feed: {
                                  "order${i + 1}":
                                      FieldValue.increment(stockToAdd),
                                },
                              },
                            },
                            SetOptions(
                              merge: true,
                            ),
                          );
                        }
                        //   await FirebaseFirestore.instance
                        //       .collection('users')
                        //       .doc(FirebaseAuth.instance.currentUser!.uid)
                        //       .collection('Batches')
                        //       .doc(batchDocIds[index])
                        //       .set(
                        //     {
                        //       "feedTypeQuantity": {
                        //         feed: FieldValue.increment(stockForType),
                        //       },
                        //     },
                        //     SetOptions(
                        //       merge: true,
                        //     ),
                        //   );
                      }
                    }
                  }
                });
                //backup
                // await FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(FirebaseAuth.instance.currentUser!.uid)
                //     .collection('Batches')
                //     .doc(batchDocIds[index])
                //     .set(
                //   {
                //     "feedTypeQuantity": {
                //       feed: FieldValue.increment(stockToAdd),
                //
                //     },
                //   },
                //   SetOptions(
                //     merge: true,
                //   ),
                // );

                showDialog(
                    context: context,
                    builder: (context) => const ShowDialogBox(
                          message: "Feed Transferred!!",
                          isShowAds: false,
                          
                        ));

                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
