import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addexpenses.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/searchbox.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  String docId;
  int accessLevel;
  String owner;
  ExpensesPage(
      {super.key,
      required this.docId,
      required this.accessLevel,
      required this.owner});
  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  List expenses = [];
  bool isLoading = true;
  bool containsChicks = false;

  Future<void> getExpenses() async {
    setState(() {
      isLoading = true;
      expenses.clear();
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
          if (value.data()!["expenseDetails"][i]["Expenses Category"] ==
              "Chicks") {
            setState(() {
              containsChicks = true;
            });
          }

          setState(() {
            expenses.add({
              "Amount": double.parse(
                  value.data()!["expenseDetails"][i]["Amount"].toString()),
              "Date": value.data()!["expenseDetails"][i]["Date"],
              "Description": value.data()!["expenseDetails"][i]["Description"],
              "Expenses Category": value.data()!["expenseDetails"][i]
                  ["Expenses Category"],
              "NoOfChicksThen": value.data()!["expenseDetails"][i]
                  ["NoOfChicksThen"],
            });
          });
        }
      }

      DateFormat inputFormat = DateFormat("dd/MM/yyyy");

      setState(() {
        expenses.sort((first, second) {
          String date1 = first["Date"];
          String date2 = second["Date"];
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
      print(expenses);
    });

    setState(() {
      isLoading = false;
    });

    print(expenses);
  }

  @override
  void initState() {
    super.initState();
    if (widget.accessLevel != 2) {
      getExpenses();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddExpensesPage(
                            docId: widget.docId,
                            owner: widget.owner,
                            containsChicks: containsChicks,
                          ))).then((value) {
                if (value == null) {
                  return;
                } else {
                  if (value) {
                    getExpenses();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    "Expenses",
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
            const Divider(),
            isLoading
                ? const CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      List date = expenses[index]["Date"].toString().split("/");
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

                      DateTime expenseDate = DateTime.utc(year, month, day);
                      return InkWell(
                        onTap: () {
                          if (expenses[index]["Expenses Category"] ==
                                  "Chicks" ||
                              expenses[index]["Expenses Category"] ==
                                  "Feed Served") {
                            Fluttertoast.showToast(
                                msg:
                                    "Chicks and Feed Served entries cannot be edited!");
                          } else {
                            if (widget.accessLevel == 1) {
                              //view
                              Fluttertoast.showToast(
                                  msg:
                                      "You don't have the required permissions to edit!");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddExpensesPage(
                                    docId: widget.docId,
                                    owner: widget.owner,
                                    description: expenses[index]["Description"],
                                    amount: expenses[index]["Amount"],
                                    date: expenses[index]["Date"],
                                    expensesCategory: expenses[index]
                                        ["Expenses Category"],
                                    noOfChicksThen: expenses[index]
                                        ["NoOfChicksThen"],
                                    isEdit: true,
                                    upto: expenses.sublist(0, index),
                                    after: expenses.sublist(
                                      index + 1,
                                    ),
                                  ),
                                ),
                              ).then((value) {
                                if (value == null) {
                                  return;
                                } else {
                                  if (value) {
                                    getExpenses();
                                  }
                                }
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd/MM/yyyy").format(expenseDate),
                                    style: bodyText12normal(color: darkGray),
                                  ),
                                  Text(
                                    "${expenses[index]["Description"]}",
                                    style: bodyText15w500(color: black),
                                  ),
                                  Text(
                                    "${expenses[index]["Expenses Category"]}",
                                    style: bodyText12normal(color: darkGray),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Image.asset("assets/images/share.png"),
                                      // addHorizontalySpace(10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40.0,
                                        ),
                                        child: InkWell(
                                          child: const Icon(
                                              Icons.delete_outline_rounded),
                                          onTap: () {
                                            if (expenses[index]
                                                    ["Expenses Category"] ==
                                                "Chicks") {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Cannot delete entry for Chicks!");
                                            } else {
                                              showDialog(
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
                                                          builder: (context) {
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
                                                                  height * 0.15,
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
                                                                    child: Text(
                                                                      "Do you want to delete this item?",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              width * 0.3,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: yellow),
                                                                              borderRadius: BorderRadius.circular(6)),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                                                          if (widget.accessLevel ==
                                                                              1) {
                                                                            //view
                                                                            Fluttertoast.showToast(msg: "You don't have the required permissions to edit!");
                                                                            Navigator.pop(context,
                                                                                false);
                                                                          } else {
                                                                            await FirebaseFirestore.instance.collection("users").doc(widget.owner).collection("Batches").doc(widget.docId).collection("BatchData").doc("Expenses").set({
                                                                              "expenseDetails": expenses.sublist(0, index) +
                                                                                  expenses.sublist(
                                                                                    index + 1,
                                                                                  ),
                                                                            });
                                                                            Fluttertoast.showToast(msg: "Deletion successful!");

                                                                            Navigator.pop(context,
                                                                                true);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              width * 0.3,
                                                                          decoration: BoxDecoration(
                                                                              color: red,
                                                                              borderRadius: BorderRadius.circular(6)),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                                    getExpenses();
                                                  }
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    double.parse(expenses[index]["Amount"].toString()).toStringAsFixed(2),
                                    style: bodyText18w600(color: red),
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
                    itemCount: expenses.length),
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
