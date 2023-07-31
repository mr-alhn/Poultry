import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/farmsettings/addexpensescat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddExpensesPage extends StatefulWidget {
  String docId;
  String owner;
  bool? isEdit = false;
  int? noOfChicksThen;
  double? amount;
  String? date;
  String? expensesCategory;
  String? description;
  List? upto;
  List? after;
  bool? containsChicks = false;

  AddExpensesPage({
    super.key,
    required this.docId,
    required this.owner,
    this.isEdit,
    this.amount,
    this.description,
    this.date,
    this.expensesCategory,
    this.upto,
    this.noOfChicksThen,
    this.after,
    this.containsChicks,
  });

  @override
  State<AddExpensesPage> createState() => _AddExpensesPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;
List<dynamic> expenseType = [];

class _AddExpensesPageState extends State<AddExpensesPage> {
  final _formKey = GlobalKey<FormState>();

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final expensesCategoryController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String expenseTypeString = "";
  int noChicks = 0;
  int noChicksThen = 0;

  DateTime batchDate = DateTime.utc(1800, 01, 01);
  int length = 0;

  Future<void> getExpenseType() async {
    expenseType.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.owner)
        .collection('settings')
        .doc('Expense Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          expenseType = value.data()?['expenseType'] ?? [];
          if (expenseType.contains("Chicks") && widget.containsChicks == true) {
            expenseType.remove("Chicks");
          }
        });
      } else {
        setState(() {
          expenseType.add("Chicks");
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.owner)
            .collection('settings')
            .doc('Expense Type')
            .set({
          "expenseType": expenseType,
        });
      }
    });
  }

  Future<void> getNoChicks() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
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
        noChicks = int.parse(value.data()!["NoOfBirds"].toString());
        noChicksThen = int.parse(value.data()!["NoOfBirds"].toString()) -
            int.parse(value.data()!["Sold"].toString()) -
            int.parse(value.data()!["Mortality"].toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      setState(() {
        descriptionController.text = widget.description!;
        amountController.text = widget.amount.toString();
        dateController.text = widget.date!;
        expenseTypeString = widget.expensesCategory!;
        expensesCategoryController.text = widget.expensesCategory!;
      });
    }
    getNoChicks();
    getExpenseType();
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
            children: [
              addVerticalSpace(15),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Add Expenses",
                              style: bodyText22w600(color: black),
                            ),
                          ),
                          addVerticalSpace(20),
                          CustomTextField(
                              hintText: "Date",
                              suffix: true,
                              // enabled: false,
                              controller: dateController,
                              cannotSelectBefore: batchDate,
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter Date';
                                }
                                return null;
                              }),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomDropdown(
                                list: widget.isEdit == true ? [] : expenseType,
                                height: 58,
                                hint: widget.expensesCategory ??
                                    "Expenses Category",
                                onchanged: (value) async {
                                  await getNoChicks();
                                  setState(() {
                                    expenseTypeString = value;
                                  });
                                },
                              )),
                              addHorizontalySpace(15),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const AddExpensesCategory()))
                                      .then((value) {
                                    if (value == null) {
                                      return;
                                    } else {
                                      if (value) {
                                        getExpenseType();
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  height: 58,
                                  width: 58,
                                  decoration: shadowDecoration(10, 0, yellow),
                                  child: Center(
                                      child: Icon(
                                    Icons.add,
                                    color: white,
                                  )),
                                ),
                              )
                            ],
                          ),
                          CustomTextField(
                              hintText: expenseTypeString == "Chicks"
                                  ? "Amount Per Chick"
                                  : "Amount",
                              controller: amountController,
                              textType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Amount';
                                }
                                return null;
                              }),
                          CustomTextField(
                            hintText: "Description",
                            controller: descriptionController,
                          ),
                        ]),
                  ),
                ),
              ]),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: CustomButton(
                    text: "Cash Out",
                    onClick: () async {
                      if (widget.isEdit == true) {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.owner)
                              .collection("Batches")
                              .doc(widget.docId)
                              .collection("BatchData")
                              .doc("Expenses")
                              .set({
                            "expenseDetails": widget.upto! +
                                [
                                  {
                                    'Date': dateController.text.toString(),
                                    'Expenses Category': expenseTypeString,
                                    'Amount': expenseTypeString == "Chicks"
                                        ? double.parse(amountController.text
                                                .toString()) *
                                            noChicks
                                        : double.parse(
                                            amountController.text.toString()),
                                    "NoOfChicksThen": widget.noOfChicksThen,
                                    'Description':
                                        descriptionController.text.toString(),
                                  }
                                ] +
                                widget.after!,
                          });

                          Fluttertoast.showToast(
                              msg: "Expense Details updated!");
                          Navigator.pop(context, true);
                        }
                      } else {
                        if (expenseTypeString == "Chicks") {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    contentPadding: const EdgeInsets.all(6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    content: Builder(builder: (context) {
                                      var height =
                                          MediaQuery.of(context).size.height;
                                      var width =
                                          MediaQuery.of(context).size.width;

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
                                                "This action is not reversible. Are you sure you want to continue?",
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
                                                        border: Border.all(
                                                            color: yellow),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
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
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Processing Data')),
                                                      );

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(widget.owner)
                                                          .collection("Batches")
                                                          .doc(widget.docId)
                                                          .collection(
                                                              "BatchData")
                                                          .doc("Expenses")
                                                          .set(
                                                              {
                                                            "expenseDetails":
                                                                FieldValue
                                                                    .arrayUnion([
                                                              {
                                                                'Date': dateController
                                                                    .text
                                                                    .toString(),
                                                                'Expenses Category':
                                                                    expenseTypeString,
                                                                'Amount': double.parse(
                                                                        amountController
                                                                            .text
                                                                            .toString()) *
                                                                    noChicks,
                                                                'Description':
                                                                    descriptionController
                                                                        .text
                                                                        .toString(),
                                                                "NoOfChicksThen":
                                                                    noChicksThen,
                                                              }
                                                            ])
                                                          },
                                                              SetOptions(
                                                                  merge: true));

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(widget.owner)
                                                          .collection("Batches")
                                                          .doc(widget.docId)
                                                          .set(
                                                              {
                                                            "CostPerBird":
                                                                amountController
                                                                    .text
                                                                    .toString(),
                                                          },
                                                              SetOptions(
                                                                  merge: true));
                                                      Navigator.pop(
                                                          context, true);
                                                      Navigator.pop(
                                                          context, true);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: width * 0.3,
                                                    decoration: BoxDecoration(
                                                        color: yellow,
                                                        border: Border.all(
                                                            color: yellow),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
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
                        } else {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.owner)
                                .collection("Batches")
                                .doc(widget.docId)
                                .collection("BatchData")
                                .doc("Expenses")
                                .set({
                              "expenseDetails": FieldValue.arrayUnion([
                                {
                                  'Date': dateController.text.toString(),
                                  'Expenses Category': expenseTypeString,
                                  'Amount': double.parse(
                                      amountController.text.toString()),
                                  'Description':
                                      descriptionController.text.toString(),
                                  "NoOfChicksThen": noChicksThen,
                                }
                              ])
                            }, SetOptions(merge: true));

                            Navigator.pop(context, true);
                          }
                        }
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
