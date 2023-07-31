import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addvaccination.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class VaccinationPage extends StatefulWidget {
  String batchId;
  String owner;
  int accessLevel;
  VaccinationPage(
      {super.key,
      required this.batchId,
      required this.accessLevel,
      required this.owner});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  int index = 0;
  List vaccinationDetails = [];
  List editDetails = [];
  bool isLoading = true;
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchData() async {
    setState(() {
      isLoading = true;
      vaccinationDetails.clear();
      editDetails.clear();
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
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
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Vaccination")
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()!["vaccinationDetails"].length; i++) {
          List dates = value
              .data()!["vaccinationDetails"][i]["date"]
              .toString()
              .split("/");
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
          DateTime vaccinationDate = DateTime.utc(year, month, day);
          setState(() {
            vaccinationDetails.add({
              "date": DateFormat("dd/MM/yyyy").format(vaccinationDate),
              "day": vaccinationDate.difference(batchDate).inDays + 1,
              "name": value.data()!["vaccinationDetails"][i]["vaccineName"],
              "vaccineType": value.data()!["vaccinationDetails"][i]
                  ["vaccineType"],
              "method": value.data()!["vaccinationDetails"][i]["method"],
              "description": value.data()!["vaccinationDetails"][i]
                  ["Description"],
            });

            editDetails.add({
              "date": value.data()!["vaccinationDetails"][i]["date"],
              "method": value.data()!["vaccinationDetails"][i]["method"],
              "vaccineName": value.data()!["vaccinationDetails"][i]
                  ["vaccineName"],
              "vaccineType": value.data()!["vaccinationDetails"][i]
                  ["vaccineType"],
              "Description": value.data()!["vaccinationDetails"][i]
                  ["Description"],
            });
          });
        }
        DateFormat inputFormat = DateFormat("dd/MM/yyyy");
        setState(() {
          vaccinationDetails.sort((first, second) =>
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
        print(vaccinationDetails);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBatchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: index == 1
          ? widget.accessLevel == 0 || widget.accessLevel == 2
              ? FloatedButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddVaccinationPage(
                                  docId: widget.batchId,
                                  owner: widget.owner,
                                ))).then((value) {
                      if (value == null) {
                        return;
                      } else {
                        if (value) {
                          getBatchData();
                        }
                      }
                    });
                  },
                )
              : null
          : null,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  "Vaccination",
                  style: bodyText22w600(color: black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                          buttonColor: index == 0 ? yellow : utbColor,
                          textStyle: bodyText12w600(
                              color: index == 0 ? white : darkGray),
                          text: "Vaccination Schedule",
                          onClick: () async {
                            setState(() {
                              index = 0;
                            });
                          },
                          width: width(context),
                          height: 40),
                    ),
                    addHorizontalySpace(15),
                    Expanded(
                      child: CustomButton(
                          buttonColor: index == 1 ? yellow : utbColor,
                          textStyle: bodyText12w600(
                              color: index == 1 ? white : darkGray),
                          text: "Actual Vaccination",
                          onClick: () async {
                            setState(() {
                              index = 1;
                            });
                          },
                          width: width(context),
                          height: 40),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 0,
          ),
          index == 0
              ? Center(
                  child: Text(
                  "No vaccination data",
                  style: bodyText15w500(color: black),
                ))
              : isLoading
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
                                  builder: (context) => AddVaccinationPage(
                                    docId: widget.batchId,
                                    owner: widget.owner,
                                    isEdit: true,
                                    description: vaccinationDetails[index]
                                        ["description"],
                                    batchIndex: index,
                                    date: vaccinationDetails[index]["date"],
                                    type: vaccinationDetails[index]
                                        ["vaccineType"],
                                    method: vaccinationDetails[index]["method"],
                                    name: vaccinationDetails[index]["name"],
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
                                    getBatchData();
                                  }
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${vaccinationDetails[index]["date"]} ",
                                      style: bodyText12normal(color: darkGray),
                                    ),
                                    Text(
                                      "${vaccinationDetails[index]["vaccineType"]}",
                                      style: bodyText14normal(color: darkGray),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Day ${vaccinationDetails[index]["day"]}",
                                      style: bodyText17w500(color: black),
                                    ),
                                    Text(
                                      "${vaccinationDetails[index]["method"]}",
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
                      itemCount: vaccinationDetails.length),
          const Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
