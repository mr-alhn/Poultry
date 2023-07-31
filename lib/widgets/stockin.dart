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

class StockInWidget extends StatefulWidget {
  const StockInWidget({super.key});

  @override
  State<StockInWidget> createState() => _StockInWidgetState();
}

class _StockInWidgetState extends State<StockInWidget> {
  List feedType = [];
  List batch = [];
  int stockForType = 0;
  Map availableStockDetails = {};
  String feed = "";
  String batchName = "";
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
    int index = batch.indexOf(batchName);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Batches')
        .doc(batchDocIds[index])
        .get()
        .then((value) {
      if (value.exists) {
        print('exists');
        setState(() {
          if (value.data()!["feedTypeQuantity"][feed] == null) {
            stockForType = 0;
          } else {
            // for (int i = 0;
            //     i < value.data()!["feedTypeQuantity"][feed].length;
            //     i++) {
            //   });
            //   stockForType += int.parse(value
            //       .data()!["feedTypeQuantity"][feed]["order${i + 1}"]
            //       .toString());
            // }

            Map feedTypeQuantity =
                value.data()!["feedTypeQuantity"][feed] ?? {};
            // print(feedTypeQuantity);
            for (var key in feedTypeQuantity.keys.toList()..sort()) {
              if (key != "used") {
                if (int.parse(feedTypeQuantity[key].toString()) != 0) {
                  availableStockDetails[key] =
                      int.parse(feedTypeQuantity[key].toString());
                  stockForType += int.parse(feedTypeQuantity[key].toString());
                }
              } else {
                Map usedMap = feedTypeQuantity["used"] ?? {};
                for (var key in usedMap.keys) {
                  availableStockDetails[key] -=
                      double.parse(usedMap[key].toString()).ceil();
                  stockForType -= double.parse(usedMap[key].toString()).ceil();
                }
              }
            }
          }
        });
        print(availableStockDetails);
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
                                  batchName.isNotEmpty
                                      ? batchName
                                      : "From Batch",
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
              CustomTextField(
                hintText: "Quantity: $stockForType",
                enabled: false,
              ),
              quantityButton,
            ],
          ),
          CustomButton(
              // text: "Receive Feed",
              text: 'Transfer Feed to Inventory',
              onClick: () async {
                int index = batch.indexOf(batchName);
                int quantityToTransfer = 0;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Batches')
                    .doc(batchDocIds[index])
                    .get()
                    .then((value) async {
                  if (quantityButton.current == 0) {
                    Fluttertoast.showToast(msg: "Cannot transfer 0 quantity!");
                  } else {
                    int currentStock = stockForType;

                    if (currentStock > 0) {
                      setState(() {
                        quantityToTransfer = quantityButton.current;
                      });

                      for (var key in availableStockDetails.keys) {
                        print(key);
                        if (quantityToTransfer > 0 &&
                            availableStockDetails[key] > 0) {
                          // 20 -> 10
                          if (availableStockDetails[key] >=
                              quantityToTransfer) {
                            await FirebaseFirestore.instance
                                .collection('inventory')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              key: {
                                "feedQuantity":
                                    FieldValue.increment(quantityToTransfer),
                              }
                            }, SetOptions(merge: true));

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Batches')
                                .doc(batchDocIds[index])
                                .set({
                              "feedTypeQuantity": {
                                feed: {
                                  key:
                                      FieldValue.increment(-quantityToTransfer),
                                }
                              }
                            }, SetOptions(merge: true));

                            setState(() {
                              availableStockDetails[key] -= quantityToTransfer;
                              quantityToTransfer = 0;
                            });

                            break;
                          } else {
                            // 10 - 11
                            await FirebaseFirestore.instance
                                .collection('inventory')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              key: {
                                "feedQuantity": FieldValue.increment(
                                    availableStockDetails[key]),
                              }
                            }, SetOptions(merge: true));

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('Batches')
                                .doc(batchDocIds[index])
                                .set({
                              "feedTypeQuantity": {
                                feed: {
                                  key: FieldValue.increment(
                                      -availableStockDetails[key]),
                                }
                              }
                            }, SetOptions(merge: true));

                            setState(() {
                              availableStockDetails[key] = 0;
                              quantityToTransfer -= int.parse(
                                  availableStockDetails[key].toString());
                            });
                          }
                        }
                      }

                      // await FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(FirebaseAuth.instance.currentUser!.uid)
                      //     .collection('Batches')
                      //     .doc(batchDocIds[index])
                      //     .set({
                      //   "feedTypeQuantity": availableStockDetails,
                      // });

                      // await FirebaseFirestore.instance
                      //     .collection('inventory')
                      //     .doc(FirebaseAuth.instance.currentUser!.uid)
                      //     .get()
                      //     .then((value) async {
                      //   for (int i = value.data()!.length - 1; i >= 0; i--) {
                      //     if (quantityToTransfer <= 0) {
                      //       break;
                      //     } else {
                      //       if (value.data()!["order${i + 1}"]["feedType"] ==
                      //               feed &&
                      //           (int.parse(value
                      //                   .data()!["order${i + 1}"]["feedQuantity"]
                      //                   .toString()) <
                      //               int.parse(value
                      //                   .data()!["order${i + 1}"]
                      //                       ["originalQuantity"]
                      //                   .toString()))) {
                      //         int getDifference = int.parse(value
                      //                 .data()!["order${i + 1}"]
                      //                     ["originalQuantity"]
                      //                 .toString()) -
                      //             int.parse(value
                      //                 .data()!["order${i + 1}"]["feedQuantity"]
                      //                 .toString());

                      //         if (quantityToTransfer > getDifference) {
                      //           await FirebaseFirestore.instance
                      //               .collection('inventory')
                      //               .doc(FirebaseAuth.instance.currentUser!.uid)
                      //               .set(
                      //             {
                      //               "order${i + 1}": {
                      //                 "feedQuantity": FieldValue.increment(
                      //                     quantityToTransfer - getDifference),
                      //               },
                      //             },
                      //             SetOptions(merge: true),
                      //           );
                      //           setState(() {
                      //             quantityToTransfer -= getDifference;
                      //             print(getDifference);
                      //             print(quantityToTransfer);
                      //           });
                      //         } else {
                      //           await FirebaseFirestore.instance
                      //               .collection('inventory')
                      //               .doc(FirebaseAuth.instance.currentUser!.uid)
                      //               .set(
                      //             {
                      //               "order${i + 1}": {
                      //                 "feedQuantity": FieldValue.increment(
                      //                     quantityToTransfer),
                      //               },
                      //             },
                      //             SetOptions(merge: true),
                      //           );
                      //           setState(() {
                      //             quantityToTransfer -= quantityToTransfer;
                      //             print(getDifference);
                      //             print(quantityToTransfer);
                      //           });
                      //         }
                      //       }
                      //     }
                      //   }
                      // });
                    }
                  }
                });
                if (quantityButton.current != 0) {
                  showDialog(
                      context: context,
                      builder: (context) => const ShowDialogBox(
                            message: "Feed Received!!",
                            subMessage: '',
                            isShowAds: false,
                          ));

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  });
                }
              })
        ],
      ),
    );
  }
}
