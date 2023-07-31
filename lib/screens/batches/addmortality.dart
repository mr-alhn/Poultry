import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddMortalityPage extends StatefulWidget {
  String docId;
  String owner;
  bool? isEdit = false;
  String? description;
  int? mortality;
  int? batchIndex;
  int? liveChicksNow;
  double? costThen;
  String? date;
  List? upto;
  List? after;

  AddMortalityPage({
    super.key,
    required this.docId,
    required this.owner,
    this.isEdit,
    this.date,
    this.mortality,
    this.description,
    this.batchIndex,
    this.upto,
    this.costThen,
    this.after,
  });

  @override
  State<AddMortalityPage> createState() => _AddMortalityPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddMortalityPageState extends State<AddMortalityPage> {
  final _formKey = GlobalKey<FormState>();
  int prevMortality = 0;
  double updatedPrice = 0;
  int noChicksThen = 0;
  DateTime date = DateTime.now();
  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final mortalityController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> getDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.docId)
        .get()
        .then((value) {
      List dates = value.data()!["date"].toString().split("/");
      int month = 0;
      int day = int.parse(dates[0]);
      switch (dates[1]) {
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
      int year = int.parse(dates[2]);

      setState(() {
        date = DateTime.utc(year, month, day);
        noChicksThen = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
      });
      print(date);
    });
  }

  Future<void> getFinancialAnalysis() async {
    int netBirds = 0;
    double originalPrice = 0.0;
    double totalFeedPrice = 0.0;
    double expensesDiluted = 0.0;
    int mortality = 0;
    // Map feedData = {};

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
          setState(() {
            totalFeedPrice += double.parse(
                    value.data()!["feedServed"][i]["priceForFeed"].toString()) /
                double.parse(value
                    .data()!["feedServed"][i]["liveChicksThen"]
                    .toString());
          });
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .collection("BatchData")
        .doc("Expenses")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["expenseDetails"].length; i++) {
          setState(() {
            if (value.data()!["expenseDetails"][i]["Expenses Category"] !=
                    "Chicks" &&
                value.data()!["expenseDetails"][i]["Expenses Category"] !=
                    "Feed Served") {
              expensesDiluted += double.parse(
                      value.data()!["expenseDetails"][i]["Amount"].toString()) /
                  double.parse(value
                      .data()!["expenseDetails"][i]["NoOfChicksThen"]
                      .toString());
            }
          });
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) {
      setState(() {
        mortality = int.parse(value.data()!["Mortality"].toString());
        // noChicksThen = int.parse(value.data()!["NoOfBirds"].toString()) -
        //     int.parse(value.data()!["Mortality"].toString());
      });
      int noBirds = int.parse(value.data()!["NoOfBirds"].toString());

      setState(() {
        netBirds = noBirds - mortality;
        String costBird = value.data()!["CostPerBird"] ?? "";
        if (costBird == "") {
          originalPrice = 0;
        } else {
          originalPrice = double.parse(value.data()!["CostPerBird"].toString());
        }
      });
    });
    print("Total Feed Price: $totalFeedPrice");
    print("Expenses diluted: $expensesDiluted");
    print(expensesDiluted + totalFeedPrice);
    setState(() {
      updatedPrice = originalPrice + ((expensesDiluted + totalFeedPrice));
    });
    print(updatedPrice);
    if (mortality > 0) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.owner)
          .collection("Batches")
          .doc(widget.docId)
          .collection("BatchData")
          .doc("Mortality")
          .get()
          .then((value) {
        for (int i = 0; i < value.data()!["mortalityDetails"].length; i++) {
          setState(() {
            updatedPrice += (double.parse(value
                        .data()!["mortalityDetails"][i]["costUptoHere"]
                        .toString()) *
                    int.parse(value
                        .data()!["mortalityDetails"][i]["Mortality"]
                        .toString())) /
                (int.parse(value
                    .data()!["mortalityDetails"][i]["liveChicksNow"]
                    .toString()));
          });
        }
      });
    }
    if (netBirds == 0) {
      setState(() {
        updatedPrice = originalPrice;
      });
    }
    print(updatedPrice);

    // for(var keys in incomeMap.keys.toList()){
    //   double cp = 0;

    // }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      prevMortality = 0;
    });

    getDateDetails();
    getFinancialAnalysis();
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
      body: Column(
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
                          "Add Mortality",
                          style: bodyText22w600(color: black),
                        ),
                      ),
                      addVerticalSpace(20),
                      CustomTextField(
                          hintText: "Date",
                          suffix: true,
                          controller: dateController,
                          cannotSelectBefore: date,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Date';
                            }
                            return null;
                          }),
                      CustomTextField(
                          hintText: "Mortality",
                          controller: mortalityController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Mortality';
                            }
                            return null;
                          }),
                      CustomTextField(
                        hintText: "Description",
                        controller: descriptionController,
                      )
                    ]),
              ),
            ),
          ]),
          // addVerticalSpace(height(context) * .22),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                                        "This action is not reversible. Are you sure you want to continue with Date: ${dateController.text.toString()} and Mortality: ${mortalityController.text.toString()}?",
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
                                              double totalFeedPrice = 0.0;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Processing Data')),
                                              );
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.owner)
                                                  .collection('Batches')
                                                  .doc(widget.docId)
                                                  .set({
                                                "Mortality":
                                                    FieldValue.increment(
                                                        int.parse(
                                                            mortalityController
                                                                .text
                                                                .toString())),
                                              }, SetOptions(merge: true));

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.owner)
                                                  .collection('Batches')
                                                  .doc(widget.docId)
                                                  .collection('BatchData')
                                                  .doc("Mortality")
                                                  .set({
                                                "mortalityDetails":
                                                    FieldValue.arrayUnion([
                                                  {
                                                    "Date": dateController.text
                                                        .toString(),
                                                    'Mortality': int.parse(
                                                        mortalityController.text
                                                            .toString()),
                                                    'Description':
                                                        descriptionController
                                                            .text
                                                            .toString(),
                                                    "costUptoHere":
                                                        updatedPrice,
                                                    "liveChicksNow": noChicksThen -
                                                        int.parse(
                                                            mortalityController
                                                                .text
                                                                .toString()),
                                                  }
                                                ])
                                              }, SetOptions(merge: true));

                                              Navigator.pop(context, true);
                                              Navigator.pop(context, true);
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

                  // await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(widget.owner)
                  //     .collection("Batches")
                  //     .doc(widget.docId)
                  //     .collection("BatchData")
                  //     .doc("Feed Served")
                  //     .get()
                  //     .then((value) {
                  //   if (value.exists) {
                  //     for (int i = 0;
                  //         i < value.data()!["feedServed"].length;
                  //         i++) {
                  //       setState(() {
                  //         totalFeedPrice += double.parse(value
                  //                 .data()!["feedServed"][i]["feedQuantity"]
                  //                 .toString()) *
                  //             double.parse(value
                  //                 .data()!["feedServed"][i]["priceForFeed"]
                  //                 .toString());
                  //       });
                  //     }
                  //   }
                  // });
                  // print("Feed Price ${totalFeedPrice}");
                  // int netBirds = 0;
                  // double originalPrice = 0.0;
                  // await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(widget.owner)
                  //     .collection("Batches")
                  //     .doc(widget.docId)
                  //     .get()
                  //     .then((value) {
                  //   int mortality =
                  //       int.parse(value.data()!["Mortality"].toString());

                  //   int sold = int.parse(value.data()!["Sold"].toString());
                  //   int noBirds =
                  //       int.parse(value.data()!["NoOfBirds"].toString());

                  //   setState(() {
                  //     netBirds = noBirds -
                  //         (mortality +
                  //             int.parse(
                  //                 mortalityController.text.toString())) -
                  //         sold;
                  //     originalPrice = double.parse(
                  //         value.data()!["CostPerBird"].toString());
                  //   });
                  // });

                  // setState(() {
                  //   updatedPrice =
                  //       originalPrice + (totalFeedPrice / netBirds);
                  //   updatedPrice += (updatedPrice *
                  //           int.parse(
                  //               mortalityController.text.toString())) /
                  //       netBirds;
                  // });

                  // if (netBirds == 0) {
                  //   updatedPrice = originalPrice;
                  // }

                  // await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(widget.owner)
                  //     .collection("Batches")
                  //     .doc(widget.docId)
                  //     .collection("BatchData")
                  //     .doc("Expenses")
                  //     .set({
                  //   "expenseDetails": FieldValue.arrayUnion([
                  //     {
                  //       "Amount": updatedPrice *
                  //           int.parse(mortalityController.text.toString()),
                  //       "Date": dateController.text.toString(),
                  //       "Description": "Mortality",
                  //       "Expenses Category": "Chicks",
                  //     }
                  //   ]),
                  // }, SetOptions(merge: true));
                },
                width: width(context),
                height: 55),
          )
        ],
      ),
    );
  }
}
