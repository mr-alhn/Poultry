import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addeggs.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class EggsPage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  EggsPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  State<EggsPage> createState() => _EggsPageState();
}

class _EggsPageState extends State<EggsPage> {
  List list = [
    "Last 7 days",
    "Last 15 Days",
    "Last 1 Month",
    "Last6 Months",
    "Last 1 Year"
  ];
  List eggDetails = [];
  List editDetails = [];
  bool isLoading = true;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  int totalChicks = 0;
  Future<void> getTotalChicksAndDateDetails() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(batchDocIds[widget.index])
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
        totalChicks = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
        batchDate = DateTime.utc(year, month, day);
      });
    });
    print(totalChicks);

    getEggDetails();
  }

  Future<void> getEggDetails() async {
    setState(() {
      eggDetails.clear();
      editDetails.clear();
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection('BatchData')
        .doc("Eggs")
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()!["eggDetails"].length; i++) {
          List dates =
              value.data()!["eggDetails"][i]["date"].toString().split("/");
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
          DateTime eggDate = DateTime.utc(year, month, day);

          setState(() {
            eggDetails.add({
              "date": DateFormat("dd/MM/yyyy").format(eggDate),
              "day": eggDate.difference(batchDate).inDays + 1,
              "eggCollection": value.data()!["eggDetails"][i]
                  ["EggTrayCollection"],
              "broken": value.data()!["eggDetails"][i]["Broken"],
              "costPerEgg": value.data()!["eggDetails"][i]["costPerEgg"],
              "pulletEggs": value.data()!["eggDetails"][i]["PulletEggs"],
              "liveChicksThen": value.data()!["eggDetails"][i]
                  ["liveChicksThen"],
              "description": value.data()!["eggDetails"][i]["Description"],
            });

            editDetails.add({
              "date": value.data()!["eggDetails"][i]["date"],
              'EggTrayCollection': int.parse(value
                  .data()!["eggDetails"][i]["EggTrayCollection"]
                  .toString()),
              'PulletEggs': int.parse(
                  value.data()!["eggDetails"][i]["PulletEggs"].toString()),
              'Broken': int.parse(
                  value.data()!["eggDetails"][i]["Broken"].toString()),
              'Description': value.data()!["eggDetails"][i]["Description"],
              "liveChicksThen": value.data()!["eggDetails"][i]
                  ["liveChicksThen"],
              "costPerEgg": value.data()!["eggDetails"][i]["costPerEgg"],
            });
          });
        }
        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          eggDetails.sort((first, second) => (inputFormat.parse(first["date"]))
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
        print(eggDetails);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalChicksAndDateDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEggsPage(
                            batchId: batchDocIds[widget.index],
                            owner: widget.owner,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getEggDetails();
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
            addVerticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Eggs",
                      style: bodyText22w600(color: black),
                    ),
                  ),
                  addVerticalSpace(20),
                  Row(
                    children: [
                      const Spacer(),
                      CustomDropdown(
                        hp: 5,
                        iconSize: 10,
                        dropdownColor: white,
                        bcolor: darkGray,
                        hint: "All Time",
                        height: 30,
                        width: width(context) * .35,
                        list: list,
                        textStyle: bodyText12w600(color: darkGray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ListView.separated(
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
                                builder: (context) => AddEggsPage(
                                  batchId: batchDocIds[widget.index],
                                  owner: widget.owner,
                                  isEdit: true,
                                  batchIndex: index,
                                  description: eggDetails[index]["description"],
                                  date: eggDetails[index]["date"],
                                  pulletEggs: eggDetails[index]["pulletEggs"],
                                  brokenEggs: eggDetails[index]["broken"],
                                  totalEggs: eggDetails[index]["eggCollection"],
                                  liveChicksThen: eggDetails[index]
                                      ["liveChicksThen"],
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
                                  getEggDetails();
                                }
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      DateFormat("dd/MM/yyyy")
                                                  .format(DateTime.now()) ==
                                              eggDetails[index]["date"]
                                          ? Text(
                                              "${eggDetails[index]["date"]} -- ",
                                              style: bodyText12normal(
                                                  color: darkGray),
                                            )
                                          : Text(
                                              "${eggDetails[index]["date"]}",
                                              style: bodyText12normal(
                                                  color: darkGray),
                                            ),
                                      DateFormat("dd/MM/yyyy")
                                                  .format(DateTime.now()) ==
                                              eggDetails[index]["date"]
                                          ? Text(
                                              "Today",
                                              style: bodyText12normal(
                                                  color: yellow),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Text(
                                    "Laying Percentage: ${(eggDetails[index]["eggCollection"] / double.parse(eggDetails[index]["liveChicksThen"].toString()) * 100).toStringAsFixed(2)}%",
                                    style: bodyText12normal(color: black),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Day ${eggDetails[index]["day"]}",
                                    style: bodyText17w500(color: black),
                                  ),
                                  Text(
                                    "Cost: ${double.parse(eggDetails[index]["costPerEgg"].toString()).toStringAsFixed(2)}/egg",
                                    style: bodyText14w500(color: black),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Egg Collection: ${eggDetails[index]["eggCollection"]}",
                                    style: bodyText10normal(color: black),
                                  ),
                                  Text(
                                      "Pullet Eggs: ${eggDetails[index]["pulletEggs"]}",
                                      style: bodyText10normal(color: black)),
                                  Text(
                                      "Broken Eggs: ${eggDetails[index]["broken"]}",
                                      style: bodyText10normal(color: black)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 8,
                      );
                    },
                    itemCount: eggDetails.length),
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
