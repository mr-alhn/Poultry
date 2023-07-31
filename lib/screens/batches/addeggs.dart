import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddEggsPage extends StatefulWidget {
  String owner;
  String batchId;
  int? batchIndex;
  bool? isEdit = false;
  String? date;
  int? totalEggs;
  int? pulletEggs;
  int? brokenEggs;
  String? liveChicksThen;
  String? description;
  List? upto;
  List? after;

  AddEggsPage({
    super.key,
    required this.batchId,
    required this.owner,
    this.batchIndex,
    this.isEdit,
    this.totalEggs,
    this.pulletEggs,
    this.brokenEggs,
    this.description,
    this.liveChicksThen,
    this.date,
    this.upto,
    this.after,
  });

  @override
  State<AddEggsPage> createState() => _AddEggsPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddEggsPageState extends State<AddEggsPage> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final eggTrayCollectionController = TextEditingController();
  final pulletEggsController = TextEditingController();
  final brokenController = TextEditingController();
  final descriptionController = TextEditingController();
  double costPerEgg = 0.0;
  int totalChicks = 0;

  DateTime date = DateTime.now();
  Future<void> getDateDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.batchId)
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
        totalChicks = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
      });
      print(date);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      setState(() {
        dateController.text = DateFormat("dd/MMM/yyyy")
            .format(DateFormat("dd/MM/yyyy").parse(widget.date!))
            .toLowerCase();
        eggTrayCollectionController.text = widget.totalEggs.toString();
        pulletEggsController.text = widget.pulletEggs.toString();
        brokenController.text = widget.brokenEggs.toString();
        descriptionController.text = widget.description.toString();
      });
    }
    getDateDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Batch",
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        addVerticalSpace(15),
                        Text(
                          "Add Eggs",
                          style: bodyText22w600(color: black),
                        ),
                        addVerticalSpace(20),
                        CustomTextField(
                          hintText: "Date",
                          suffix: true,
                          controller: dateController,
                          cannotSelectBefore: date,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter date";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: "Total Eggs",
                          controller: eggTrayCollectionController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter tray";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: "Pullet Eggs",
                          controller: pulletEggsController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter pullet Eggs";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: "Broken",
                          controller: brokenController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter broken eggs";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hintText: "Description",
                          controller: descriptionController,
                        )
                      ]),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(height(context) * 0.16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: CustomButton(
                    text: "Save",
                    onClick: () async {
                      //check first if today's feed exists!

                      if (widget.isEdit == true) {
                        Map current = {};

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.batchId)
                            .collection("BatchData")
                            .doc("Feed Served")
                            .get()
                            .then((value) async {
                          //find total feed served for today!
                          double feedCostToday = 0.0;
                          double costPerEgg = 0.0;
                          bool doesContain = false;
                          if (value.exists) {
                            for (int i = 0;
                                i < value.data()!["feedServed"].length;
                                i++) {
                              if (value.data()!["feedServed"][i]["date"] ==
                                  dateController.text.toString()) {
                                setState(() {
                                  doesContain = true;
                                });

                                setState(() {
                                  feedCostToday += double.parse(value
                                      .data()!["feedServed"][i]["priceForFeed"]
                                      .toString());
                                });
                              }
                            }

                            if (doesContain) {
                              setState(() {
                                costPerEgg = feedCostToday /
                                    (int.parse(eggTrayCollectionController.text
                                        .toString()));
                              });
                              current.addAll({
                                "date": dateController.text.toString(),
                                'EggTrayCollection': int.parse(
                                    eggTrayCollectionController.text
                                        .toString()),
                                'PulletEggs': int.parse(
                                    pulletEggsController.text.toString()),
                                'Broken':
                                    int.parse(brokenController.text.toString()),
                                'Description':
                                    descriptionController.text.toString(),
                                "costPerEgg": costPerEgg,
                                "liveChicksThen": widget.liveChicksThen,
                              });

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.owner)
                                  .collection("Batches")
                                  .doc(widget.batchId)
                                  .collection("BatchData")
                                  .doc("Eggs")
                                  .set({
                                "eggDetails":
                                    widget.upto! + [current] + widget.after!,
                              });
                              Fluttertoast.showToast(
                                  msg: "Data updated successfully!");
                              Navigator.pop(context, true);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Feed data doesn't exist for that day!");
                            }
                          }
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.owner)
                            .collection("Batches")
                            .doc(widget.batchId)
                            .collection("BatchData")
                            .doc("Feed Served")
                            .get()
                            .then((value) async {
                          //find total feed served for today!
                          double feedCostToday = 0.0;
                          double costPerEgg = 0.0;
                          bool doesContain = false;
                          if (value.exists) {
                            for (int i = 0;
                                i < value.data()!["feedServed"].length;
                                i++) {
                              if (value.data()!["feedServed"][i]["date"] ==
                                  dateController.text.toString()) {
                                setState(() {
                                  doesContain = true;
                                });

                                setState(() {
                                  feedCostToday += (double.parse(value
                                      .data()!["feedServed"][i]["priceForFeed"]
                                      .toString()));
                                });
                              }
                            }

                            if (doesContain) {
                              setState(() {
                                costPerEgg = feedCostToday /
                                    (int.parse(eggTrayCollectionController.text
                                        .toString()));
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.owner)
                                  .collection("Batches")
                                  .doc(widget.batchId)
                                  .collection("BatchData")
                                  .doc("Eggs")
                                  .set({
                                "eggDetails": FieldValue.arrayUnion([
                                  {
                                    "date": dateController.text.toString(),
                                    'EggTrayCollection': int.parse(
                                        eggTrayCollectionController.text
                                            .toString()),
                                    'PulletEggs': int.parse(
                                        pulletEggsController.text.toString()),
                                    'Broken': int.parse(
                                        brokenController.text.toString()),
                                    'Description':
                                        descriptionController.text.toString(),
                                    "costPerEgg": costPerEgg,
                                    "liveChicksThen": totalChicks.toString(),
                                  }
                                ])
                              }, SetOptions(merge: true));

                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );

                                Navigator.pop(context, true);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Enter feed for today!");
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Add Feed Served Details first!");
                          }
                        });
                      }
                    },
                    width: width(context),
                    height: 55),
              )
            ],
          ),
        ),
      ),
    );
  }
}
