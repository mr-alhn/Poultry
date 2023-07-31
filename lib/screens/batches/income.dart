import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addincome.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/screens/farmsettings/incomecat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/searchbox.dart';
import 'package:intl/intl.dart';


class IncomePage extends StatefulWidget {
  final int index;
  final int accessLevel;
  String owner;

  IncomePage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List incomeDetails = [];
  bool isLoading = true;

  Future<void> getIncomeDetails() async {
    setState(() {
      isLoading = true;
      incomeDetails.clear();
    });

    // DateFormat inputFormat = DateFormat("dd/MMM/yyyy");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Income")
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          for (int i = 0; i < value.data()!["incomeDetails"].length; i++) {
            incomeDetails.add({
              "BillAmount": value.data()!["incomeDetails"][i]["BillAmount"],
              "date": value.data()!["incomeDetails"][i]["date"],
              "name": value.data()!["incomeDetails"][i]["name"],
              "IncomeCategory": value.data()!["incomeDetails"][i]
                  ["IncomeCategory"],
              "AmountDue": double.parse(
                  value.data()!["incomeDetails"][i]["AmountDue"].toString()),
              "Contact": value.data()!["incomeDetails"][i]["Contact"],
              "Weight": double.parse(
                  value.data()!["incomeDetails"][i]["Weight"].toString()),
              "Rate": double.parse(
                  value.data()!["incomeDetails"][i]["Rate"].toString()),
              "Quantity": int.parse(
                  value.data()!["incomeDetails"][i]["Quantity"].toString()),
              "PaymentMethod": value.data()!["incomeDetails"][i]
                  ["PaymentMethod"],
              "CostPerBird": double.parse(
                  value.data()!["incomeDetails"][i]["CostPerBird"].toString()),
              "AmountPaid": double.parse(
                  value.data()!["incomeDetails"][i]["AmountPaid"].toString()),
              "Description": value.data()!["incomeDetails"][i]["Description"],
            });
          }
        });

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          incomeDetails.sort((first, second) =>
              (inputFormat.parse(first["date"]))
                  .compareTo((inputFormat.parse(second["date"]))));
        });
        print(incomeDetails);
      } else {
        setState(() {
          incomeDetails = [];
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getIncomeDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              //print(batchDocIds[widget.index]);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddIncomePage(
                            incomeCategoryList: incomeCategoryList,
                            index: widget.index,
                            owner: widget.owner,
                            isEdit: false,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getIncomeDetails();
                  }
                }
              });
            })
          : null,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Income",
                    style: bodyText22w600(color: black),
                  ),
                  addVerticalSpace(20),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: "Coming Soon!");
                    },
                    child: Row(
                      children: [
                        const Expanded(
                            child: CustomSearchBox(
                          isEnabled: false,
                        )),
                        addHorizontalySpace(12),
                        Container(
                          decoration:
                              shadowDecoration(6, 1, white, bcolor: normalGray),
                          height: 40,
                          width: 40,
                          child: Image.asset("assets/images/filter.png"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(10),
            const Divider(
              height: 0,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: MediaQuery.of(context).size.height *
                        incomeDetails.length *
                        0.1,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            height: 80,
                            child: InkWell(
                              onTap: () {
                                print('tapped');
                                print(widget.accessLevel);
                                if (widget.accessLevel == 1) {
                                  //view
                                  Fluttertoast.showToast(
                                      msg:
                                          "You don't have the required permissions to edit!");
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddIncomePage(
                                        incomeCategoryList: incomeCategoryList,
                                        index: widget.index,
                                        owner: widget.owner,
                                        isEdit: true,
                                        date: DateFormat("dd/MMM/yyyy")
                                            .format(DateFormat("dd/MM/yyyy")
                                                .parse(incomeDetails[index]
                                                    ["date"]))
                                            .toLowerCase(),
                                        name: incomeDetails[index]["name"],
                                        contact: incomeDetails[index]
                                            ["Contact"],
                                        incomeCategory: incomeDetails[index]
                                            ["IncomeCategory"],
                                        weight: incomeDetails[index]["Weight"],
                                        billDue: double.parse(
                                            incomeDetails[index]["BillAmount"]
                                                .toString()),
                                        quantity: incomeDetails[index]
                                            ["Quantity"],
                                        paymentMethod: incomeDetails[index]
                                            ["PaymentMethod"],
                                        updatedPrice: incomeDetails[index]
                                            ["CostPerBird"],
                                        amountDue: incomeDetails[index]
                                            ["AmountDue"],
                                        amountPaid: incomeDetails[index]
                                            ["AmountPaid"],
                                        description: incomeDetails[index]
                                            ["Description"],
                                        rate: incomeDetails[index]["Rate"],
                                        itemIndex: index,
                                        upto: incomeDetails.sublist(0, index),
                                        after: incomeDetails.sublist(
                                          index + 1,
                                        ),
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == null) {
                                      return;
                                    } else {
                                      if (value) {
                                        getIncomeDetails();
                                      }
                                    }
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${incomeDetails[index]["date"]}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      ),
                                      Text(
                                        "${incomeDetails[index]["name"]}",
                                        style: bodyText15w500(color: black),
                                      ),
                                      Text(
                                        "${incomeDetails[index]["IncomeCategory"]}",
                                        style:
                                            bodyText12normal(color: darkGray),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              "assets/images/share.png"),
                                          addHorizontalySpace(10),
                                          InkWell(
                                              onTap: () => showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            content: Builder(
                                                              builder:
                                                                  (context) {
                                                                var height =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height;
                                                                var width =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width;

                                                                return Container(
                                                                  height:
                                                                      height *
                                                                          0.15,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                    10.0,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      // SizedBox(
                                                                      //   height: 20.0,
                                                                      // ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "Do you want to delete this item?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              bodyText16Bold(
                                                                            color:
                                                                                black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 40,
                                                                              width: width * 0.3,
                                                                              decoration: BoxDecoration(border: Border.all(color: yellow), borderRadius: BorderRadius.circular(6)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'Cancel',
                                                                                  style: bodyText14Bold(color: black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          addHorizontalySpace(
                                                                              20),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              if (widget.accessLevel == 1) {
                                                                                //view
                                                                                Fluttertoast.showToast(msg: "You don't have the required permissions to edit!");
                                                                                Navigator.pop(context, false);
                                                                              } else {
                                                                                await FirebaseFirestore.instance.collection("users").doc(widget.owner).collection("Batches").doc(batchDocIds[widget.index]).collection("BatchData").doc("Income").set({
                                                                                  "incomeDetails": incomeDetails.sublist(0, index) +
                                                                                      incomeDetails.sublist(
                                                                                        index + 1,
                                                                                      ),
                                                                                });

                                                                                await FirebaseFirestore.instance.collection("users").doc(widget.owner).collection("Batches").doc(batchDocIds[widget.index]).set({
                                                                                  "Sold": FieldValue.increment(-incomeDetails[index]["Quantity"]),
                                                                                }, SetOptions(merge: true));

                                                                                Fluttertoast.showToast(msg: "Deletion successful!");

                                                                                Navigator.pop(context, true);
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 40,
                                                                              width: width * 0.3,
                                                                              decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(6)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'Delete',
                                                                                  style: bodyText14Bold(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ));
                                                      }).then((value) {
                                                    if (value == null) {
                                                      return;
                                                    } else {
                                                      if (value) {
                                                        getIncomeDetails();
                                                      }
                                                    }
                                                  }),
                                              child: const Icon(Icons
                                                  .delete_outline_rounded)),
                                          //Image.asset("assets/images/delete.png"),
                                        ],
                                      ),
                                      Text(
                                        double.parse(incomeDetails[index]
                                                        ["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? "${double.parse(incomeDetails[index]["AmountDue"].toString())}"
                                            : "${double.parse(incomeDetails[index]["BillAmount"].toString())}",
                                        style: double.parse(incomeDetails[index]
                                                        ["AmountDue"]
                                                    .toString()) >
                                                0
                                            ? bodyText18w600(color: red)
                                            : bodyText18w600(color: green),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 0,
                          );
                        },
                        itemCount: incomeDetails.length)),
            const Divider(
              height: 0,
            ),
            addVerticalSpace(20),
            const Divider(
              height: 0,
            ),
            addVerticalSpace(20)
          ],
        ),
      ),
    );
  }
}
