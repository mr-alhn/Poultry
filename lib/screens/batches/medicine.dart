import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addmedicine.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class MedicinePage extends StatefulWidget {
  int index;
  int accessLevel;
  String owner;
  MedicinePage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});
  @override
  MyMedicinePageState createState() => MyMedicinePageState();
}

class MyMedicinePageState extends State<MedicinePage> {
  List medicineDetails = [];
  List editDetails = [];
  DateTime batchDate = DateTime.utc(1800, 01, 01);
  bool isLoading = true;

  Future<void> getBatchDetails() async {
    setState(() {
      isLoading = true;
      medicineDetails.clear();
      editDetails.clear();
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
        batchDate = DateTime.utc(year, month, day);
        print(batchDate);
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Medicine")
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()?["medicineDetails"]!.length; i++) {
          List dates =
              value.data()!["medicineDetails"][i]["date"].toString().split("/");
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
          DateTime medicineDate = DateTime.utc(year, month, day);
          setState(() {
            medicineDetails.add({
              "date": DateFormat("dd/MM/yyyy").format(medicineDate),
              "day": medicineDate.difference(batchDate).inDays + 1,
              "medicine":
                  value.data()!["medicineDetails"][i]["Medicine"].toString(),
              "description":
                  value.data()!["medicineDetails"][i]["Description"].toString(),
            });

            editDetails.add({
              "Description": value.data()!["medicineDetails"][i]["Description"],
              "Medicine":
                  value.data()!["medicineDetails"][i]["Medicine"].toString(),
              "date": value.data()!["medicineDetails"][i]["date"].toString(),
            });
          });
        }
        DateFormat inputFormat = DateFormat("dd/MM/yyyy");

        setState(() {
          medicineDetails.sort((first, second) =>
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
        print(medicineDetails);
        print(editDetails);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBatchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddMedicinePage(
                          batchId: batchDocIds[widget.index],
                          owner: widget.owner))).then((value) {
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
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Text(
            "Medicine",
            style: bodyText22w600(color: black),
          ),
          addVerticalSpace(20),
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
                              builder: (context) => AddMedicinePage(
                                batchId: batchDocIds[widget.index],
                                owner: widget.owner,
                                isEdit: true,
                                date: medicineDetails[index]["date"],
                                description: medicineDetails[index]
                                    ["description"],
                                medicine: medicineDetails[index]["medicine"],
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
                                getBatchDetails();
                              }
                            }
                          });
                        }
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicineDetails[index]["date"],
                              style: bodyText12normal(color: darkGray),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Day ${medicineDetails[index]["day"]}",
                                  style: bodyText17w500(color: black),
                                ),
                                Text(
                                  medicineDetails[index]["medicine"],
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
                  itemCount: medicineDetails.length),
          const Divider(
            height: 0,
          ),
          addVerticalSpace(20)
        ],
      ),
    );
  }
}
