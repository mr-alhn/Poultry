import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addbodyweight.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class BodyWeightPage extends StatefulWidget {
  String batchId;
  int accessLevel;
  String owner;

  BodyWeightPage(
      {super.key,
      required this.batchId,
      required this.accessLevel,
      required this.owner});

  @override
  State<BodyWeightPage> createState() => _BodyWeightPageState();
}

class _BodyWeightPageState extends State<BodyWeightPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];

  List weightDetails = [];
  List editDetails = [];
  String breedType = "";
  int netBirds = 0;
  DateTime batchDate = DateTime.utc(1800, 01, 01);
  bool isLoading = true;

  Future<void> getDateDetails() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(widget.batchId)
        .get()
        .then((value) {
      setState(() {
        breedType = value.data()!["Breed"];
        netBirds = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
      });
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
        batchDate = DateTime.utc(year, month, day);
      });
      print(batchDate);
    });

    getWeightDetails();
  }

  @override
  void initState() {
    super.initState();
    getDateDetails();
  }

  Future<void> getWeightDetails() async {
    double feedGivenDay = 0.0;
    Map feedDetails = {};

    setState(() {
      weightDetails.clear();
      editDetails.clear();
      feedDetails.clear();
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          List dates =
              value.data()!["feedServed"][i]["date"].toString().split("/");
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
          DateTime weightDate = DateTime.utc(year, month, day);

          if (feedDetails.containsKey(weightDate)) {
            setState(() {
              feedDetails[weightDate] += double.parse(
                  value.data()!["feedServed"][i]["feedQuantity"].toString());
            });
          } else {
            setState(() {
              feedDetails[weightDate] = double.parse(
                  value.data()!["feedServed"][i]["feedQuantity"].toString());
            });
          }
        }
      }
      print(feedDetails);
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Body Weight")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["weightDetails"].length; i++) {
          List dates =
              value.data()!["weightDetails"][i]["date"].toString().split("/");
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
          DateTime bodyWeightDate = DateTime.utc(year, month, day);
          setState(() {
            feedGivenDay = 0;
          });
          for (DateTime dates in feedDetails.keys.toList()) {
            if (bodyWeightDate.isAfter(dates) ||
                bodyWeightDate.isAtSameMomentAs(dates)) {
              setState(() {
                feedGivenDay += feedDetails[dates];
              });
            }
          }

          print(feedGivenDay);

          setState(() {
            weightDetails.add({
              "bodyWeight": double.parse(
                  value.data()!["weightDetails"][i]["bodyWeight"].toString()),
              "date": DateFormat("dd/MM/yyyy").format(bodyWeightDate),
              "day": bodyWeightDate.difference(batchDate).inDays + 1,
              "fcr": double.parse((((feedGivenDay * 1000) /
                              double.parse(value
                                  .data()!["weightDetails"][i]["bodyWeight"]
                                  .toString())) /
                          double.parse(value
                              .data()!["weightDetails"][i]["liveChicksThen"]
                              .toString()))
                      .toString())
                  .toStringAsFixed(2),
              "liveChicksThen": int.parse(value
                  .data()!["weightDetails"][i]["liveChicksThen"]
                  .toString()),
            });

            editDetails.add({
              "date": value.data()!["weightDetails"][i]["date"],
              "bodyWeight": value.data()!["weightDetails"][i]["bodyWeight"],
              "liveChicksThen": int.parse(value
                  .data()!["weightDetails"][i]["liveChicksThen"]
                  .toString()),
            });
          });
        }

        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          weightDetails.sort((first, second) =>
              (inputFormat.parse(first["date"]))
                  .compareTo((inputFormat.parse(second["date"]))));

          editDetails.sort((first, second) {
            String date1 = first["date"];
            String date2 = second["date"];
            DateTime dateTime1 = DateTime.now(), dateTime2 = DateTime.now();

            List date = date1.toString().split("/");
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

            setState(() {
              dateTime1 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            date = date2.toString().split("/");
            month = 0;
            day = int.parse(date[0]);
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
            year = int.parse(date[2]);

            setState(() {
              dateTime2 = inputFormat
                  .parse(inputFormat.format(DateTime.utc(year, month, day)));
            });

            return (dateTime1).compareTo(dateTime2);
          });
        });
        print(weightDetails);
      }
      setState(() {
        isLoading = false;
      });
    });
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
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBodyWeight(
                            batchId: widget.batchId,
                            owner: widget.owner,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getWeightDetails();
                  }
                }
              });
            })
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Body Weight",
                    style: bodyText22w600(color: black),
                  ),
                ),
                addVerticalSpace(15),
                // Row(
                //   children: [
                //     Spacer(),
                //     CustomDropdown(
                //       hp: 5,
                //       list: list,
                //       height: 30,
                //       hint: "Last 15 days",
                //       iconSize: 10,
                //       textStyle: bodyText12w600(color: darkGray),
                //       width: width(context) * .35,
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (widget.accessLevel == 1) {
                          //view
                          Fluttertoast.showToast(
                              msg:
                                  "You don't have the required permissions to edit!");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBodyWeight(
                                batchId: widget.batchId,
                                owner: widget.owner,
                                bodyWeight: double.parse(weightDetails[index]
                                        ["bodyWeight"]
                                    .toString()),
                                date: weightDetails[index]["date"],
                                liveChicksThen: weightDetails[index]
                                    ["liveChicksThen"],
                                isEdit: true,
                                batchIndex: index,
                                upto: editDetails.sublist(0, index),
                                after: editDetails.sublist(
                                  index + 1,
                                ),
                              ),
                            ),
                          ).then((value) {
                            if (value == null) {
                              return;
                            } else {
                              if (value) {
                                getWeightDetails();
                              }
                            }
                          });
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${weightDetails[index]["date"]}",
                                  style: bodyText12normal(color: darkGray),
                                ),
                                Text(
                                  "Day ${weightDetails[index]["day"]}",
                                  style: bodyText17w500(color: black),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${weightDetails[index]["bodyWeight"]} gms",
                                  style: bodyText14normal(color: darkGray),
                                ),
                                Text(
                                  "FCR: ${weightDetails[index]["fcr"]}",
                                  style: bodyText14normal(color: darkGray),
                                )
                              ],
                            )
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
                  itemCount: weightDetails.length),
          const Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
