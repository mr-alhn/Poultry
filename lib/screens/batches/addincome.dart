import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddIncomePage extends StatefulWidget {
  final List<String> incomeCategoryList;
  String? date;
  String? name;
  String? contact;
  String? incomeCategory;
  double? billDue;
  double? rate;
  String? paymentMethod;
  double? amountPaid;
  double? weight;
  int? quantity;
  double? updatedPrice;
  double? amountDue;
  String? description;
  final int index;
  int? itemIndex;
  bool? isEdit = false;
  String owner;
  List? upto;
  List? after;

  AddIncomePage({super.key, 
    required this.incomeCategoryList,
    required this.index,
    required this.owner,
    this.date,
    this.name,
    this.itemIndex,
    this.contact,
    this.incomeCategory,
    this.billDue,
    this.quantity,
    this.paymentMethod,
    this.amountDue,
    this.weight,
    this.amountPaid,
    this.description,
    this.updatedPrice,
    this.rate,
    this.isEdit,
    this.upto,
    this.after,
  });

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

//var user = FirebaseAuth.instance.currentUser?.uid;
class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();

  // final fireStore = FirebaseFirestore.instance.collection('users').
  // doc(user).
  // collection("Batches").
  // doc(batchDocIds[widget.index]).
  // collection("AddIncome");
  bool isLoading = false;
  List incomeCategory = [];
  int soldBefore = 0;
  int noChicks = 0;
  List paymentList = ['Cash', 'Online', 'Unpaid'];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int selectedIndex = 0;
  String? method;
  String batchType = "";
  int quantity = 0;
  double updatedPrice = 0.0;
  double weight = 0.0;
  double rate = 0.0;
  double billAmount = 0.0;
  double paid = 0.0;
  double due = 0.0;
  String selectedMethod = "";
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchInformation() async {
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
      });
    });
  }

  // Future<void> getFinancialAnalysis() async {
  //   int netBirds = 0;
  //   double originalPrice = 0.0;
  //   double totalFeedPrice = 0.0;
  //   int mortality = 0;
  //   double expensesDiluted = 0.0;
  //   // Map feedData = {};

  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.owner)
  //       .collection("Batches")
  //       .doc(batchDocIds[widget.index])
  //       .collection("BatchData")
  //       .doc("Feed Served")
  //       .get()
  //       .then((value) {
  //     if (value.exists) {
  //       for (int i = 0; i < value.data()!["feedServed"].length; i++) {
  //         // if (feedData.containsKey(value.data()!["feedServed"][i]["date"])) {
  //         //   setState(() {
  //         //     feedData[value.data()!["feedServed"][i]["date"]] += (double.parse(
  //         //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
  //         //         int.parse(value
  //         //             .data()!["feedServed"][i]["feedQuantity"]
  //         //             .toString()));
  //         //   });
  //         // } else {
  //         //   setState(() {
  //         //     feedData[value.data()!["feedServed"][i]["date"]] = (double.parse(
  //         //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
  //         //         int.parse(value
  //         //             .data()!["feedServed"][i]["feedQuantity"]
  //         //             .toString()));
  //         //   });
  //         // }

  //         setState(() {
  //           totalFeedPrice += double.parse(
  //               value.data()!["feedServed"][i]["priceForFeed"].toString());
  //         });
  //       }
  //     }
  //   });

  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.owner)
  //       .collection("Batches")
  //       .doc(batchDocIds[widget.index])
  //       .collection("BatchData")
  //       .doc("Expenses")
  //       .get()
  //       .then((value) {
  //     if (value.exists) {
  //       for (int i = 0; i < value.data()!["expenseDetails"].length; i++) {
  //         setState(() {
  //           if (value.data()!["expenseDetails"][i]["Expenses Category"] !=
  //                   "Chicks" &&
  //               value.data()!["expenseDetails"][i]["Expenses Category"] !=
  //                   "Feed Served") {
  //             expensesDiluted += double.parse(
  //                 value.data()!["expenseDetails"][i]["Amount"].toString());
  //           }
  //         });
  //       }
  //     }
  //   });

  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.owner)
  //       .collection("Batches")
  //       .doc(batchDocIds[widget.index])
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       mortality = int.parse(value.data()!["Mortality"].toString());
  //     });
  //     int noBirds = int.parse(value.data()!["NoOfBirds"].toString());

  //     setState(() {
  //       netBirds = noBirds - mortality;
  //       String costBird = value.data()!["CostPerBird"] ?? "";
  //       if (costBird == "") {
  //         originalPrice = 0;
  //       } else {
  //         originalPrice = double.parse(value.data()!["CostPerBird"].toString());
  //       }
  //     });
  //   });
  //   setState(() {
  //     updatedPrice =
  //         originalPrice + ((totalFeedPrice + expensesDiluted) / netBirds);
  //     updatedPrice += (updatedPrice * mortality) / netBirds;
  //     if (netBirds == 0) {
  //       updatedPrice = originalPrice;
  //     }
  //   });
  //   print(updatedPrice);
  // }

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
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          // if (feedData.containsKey(value.data()!["feedServed"][i]["date"])) {
          //   setState(() {
          //     feedData[value.data()!["feedServed"][i]["date"]] += (double.parse(
          //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
          //         int.parse(value
          //             .data()!["feedServed"][i]["feedQuantity"]
          //             .toString()));
          //   });
          // } else {
          //   setState(() {
          //     feedData[value.data()!["feedServed"][i]["date"]] = (double.parse(
          //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
          //         int.parse(value
          //             .data()!["feedServed"][i]["feedQuantity"]
          //             .toString()));
          //   });
          // }

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
        .doc(batchDocIds[widget.index])
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
        .doc(batchDocIds[widget.index])
        .get()
        .then((value) {
      setState(() {
        mortality = int.parse(value.data()!["Mortality"].toString());
      });
      int sold = int.parse(value.data()!["Sold"].toString());
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
          .doc(batchDocIds[widget.index])
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

  Future<void> getBatchType() async {
    await FirebaseFirestore.instance
        .collection("users")
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
      });

      if (value.data()!["Breed"] == "Layer" ||
          value.data()!["Breed"] == "Breeder Farm") {
        setState(() {
          incomeCategory = ["Chicken", "Eggs"];
        });
      } else {
        setState(() {
          incomeCategory = ["Chicken"];
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
    print(widget.isEdit);
    if (widget.isEdit == true) {
      print("Upto: ${widget.upto}");
      print("After: ${widget.after}");
      print('execute');
      setState(() {
        isLoading = true;
      });
      setState(() {
        soldBefore = widget.quantity!;
        dateController.text = widget.date!;
        quantity = widget.quantity!;
        quantityController.text = quantity.toString();
        batchType = widget.incomeCategory!;
        incomeCategoryController.text = widget.incomeCategory!;
        nameController.text = widget.name!;
        contactController.text = widget.contact!;
        weightController.text = widget.weight.toString();
        rate = widget.rate!;
        weight = widget.weight!;
        billAmountController.text =
            (widget.amountPaid! + widget.amountDue!).toString();
        rateController.text = widget.rate.toString();
        billAmount = widget.amountDue! + widget.amountPaid!;
        paid = widget.amountPaid!;
        due = widget.amountDue!;
        amountPaidController.text = widget.amountPaid.toString();
        amountDueController.text = widget.amountDue.toString();
        descriptionController.text = widget.description!;
        if (widget.paymentMethod == "Cash") {
          selectedIndex = 0;
        } else if (widget.paymentMethod == "Online") {
          selectedIndex = 1;
        } else {
          selectedIndex = 2;
        }
      });
    } else {
      dateController.text =
          DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase();
    }
    getBatchType();
    getFinancialAnalysis();
  }

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final incomeCategoryController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final rateController = TextEditingController();
  final billAmountController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final amountPaidController = TextEditingController();
  final amountDueController = TextEditingController();
  final descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // dateController = TextEditingController(
    //     text: widget.isEdit!
    //         ? widget.date
    //         : DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());

    print(batchDocIds);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addVerticalSpace(10),
                            Center(
                              child: Text(
                                "Add Income",
                                style: bodyText22w600(color: black),
                              ),
                            ),
                            addVerticalSpace(15),
                            CustomTextField(
                              hintText: "date",
                              controller: dateController,
                              cannotSelectBefore: batchDate,
                              suffix: true,
                            ),
                            CustomTextField(
                                hintText: "Name",
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Name';
                                  }
                                  return null;
                                }),
                            CustomTextField(
                                hintText: "Contact",
                                controller: contactController,
                                textType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Contact';
                                  }
                                  if (value.length != 10) {
                                    return "Enter a valid 10 digit number";
                                  }
                                  return null;
                                }),
                            Row(
                              children: [
                                Expanded(
                                    child: CustomDropdown(
                                  list: widget.isEdit! ? [] : incomeCategory,
                                  height: 58,
                                  hint: widget.incomeCategory ??
                                      "Income Category",
                                  value:
                                      incomeCategoryController.text.toString(),
                                  onchanged: (value) {
                                    setState(() {
                                      batchType = value;
                                      quantity = 0;
                                      weight = 0.0;
                                      rate = 0.0;
                                      billAmount = 0.0;
                                      paid = 0.0;
                                      due = 0.0;
                                      quantityController.clear();
                                      weightController.clear();
                                      rateController.clear();
                                      billAmountController.clear();
                                      amountPaidController.clear();
                                      amountDueController.clear();
                                    });
                                  },
                                )),
                                // addHorizontalySpace(15),
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (ctx) => AddIncomeCategory()));
                                //   },
                                //   child: Container(
                                //     height: 58,
                                //     width: 58,
                                //     decoration: shadowDecoration(10, 0, yellow),
                                //     child: Center(
                                //         child: Icon(
                                //       Icons.add,
                                //       color: white,
                                //     )),
                                //   ),
                                // )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                        enabled: !widget.isEdit!,
                                        hintText: "Quantity",
                                        controller: quantityController,
                                        textType: TextInputType.number,
                                        onchanged: (value) {
                                          if (value.toString().isEmpty) {
                                            setState(() {
                                              quantity = 0;
                                              billAmount = 0.0;
                                              billAmountController.text =
                                                  billAmount.toString();
                                              due = billAmount;
                                              amountDueController.text =
                                                  due.toString();
                                            });
                                          } else {
                                            setState(() {
                                              quantity = int.parse(value);
                                              billAmount =
                                                  batchType == "Chicken"
                                                      ? weight * rate
                                                      : quantity * rate;
                                              billAmountController.text =
                                                  billAmount.toString();
                                              due = billAmount;
                                              amountDueController.text =
                                                  due.toString();
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Quantity';
                                          }
                                          return null;
                                        })),
                                addHorizontalySpace(10),
                                batchType == "Chicken"
                                    ? Expanded(
                                        child: CustomTextField(
                                            hintText: "Wt in KG",
                                            controller: weightController,
                                            textType: TextInputType.number,
                                            onchanged: (value) {
                                              if (value.toString().isEmpty) {
                                                setState(() {
                                                  weight = 0.0;
                                                  billAmount = 0.0;
                                                  billAmountController.text =
                                                      billAmount.toString();
                                                  due = billAmount;
                                                  amountDueController.text =
                                                      due.toString();
                                                });
                                              } else {
                                                setState(() {
                                                  weight = double.parse(value);
                                                  billAmount =
                                                      batchType == "Chicken"
                                                          ? weight * rate
                                                          : quantity * rate;
                                                  due = billAmount;
                                                  amountDueController.text =
                                                      due.toString();
                                                  billAmountController.text =
                                                      billAmount.toString();
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Weight';
                                              }
                                              return null;
                                            }))
                                    : Container(),
                                batchType == "Chicken"
                                    ? addHorizontalySpace(10)
                                    : Container(),
                                Expanded(
                                    child: CustomTextField(
                                        hintText: "Rate",
                                        controller: rateController,
                                        textType: TextInputType.number,
                                        onchanged: (value) {
                                          if (value.toString().isEmpty) {
                                            setState(() {
                                              rate = 0.0;
                                              billAmount = 0.0;
                                              billAmountController.text =
                                                  billAmount.toString();
                                              due = billAmount;
                                              amountDueController.text =
                                                  due.toString();
                                            });
                                          } else {
                                            setState(() {
                                              rate = double.parse(value);

                                              billAmount =
                                                  batchType == "Chicken"
                                                      ? weight * rate
                                                      : quantity * rate;
                                              billAmountController.text =
                                                  billAmount.toString();
                                              due = billAmount;
                                              amountDueController.text =
                                                  due.toString();
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Rate';
                                          }
                                          return null;
                                        })),
                              ],
                            ),
                            CustomTextField(
                                hintText: "Bill Amount",
                                enabled: false,
                                controller: billAmountController,
                                textType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bill Amount';
                                  }
                                  return null;
                                }),
                            addVerticalSpace(5),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                "Payment Method:",
                                style: bodyText15w500(color: black),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  itemCount: paymentList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = i;
                                          if (i == 0) {
                                            selectedMethod = "Cash";
                                            paid = 0.0;
                                            amountPaidController.text =
                                                paid.toString();
                                          } else if (i == 2) {
                                            selectedMethod = "Online";
                                            paid = 0.0;
                                            amountPaidController.text =
                                                paid.toString();
                                          } else {
                                            selectedMethod = "Unpaid";
                                            paid = 0.0;
                                            amountPaidController.text =
                                                paid.toString();
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 13, right: 25.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              selectedIndex == i
                                                  ? Icons
                                                      .radio_button_checked_outlined
                                                  : Icons
                                                      .radio_button_off_outlined,
                                              color: selectedIndex == i
                                                  ? yellow
                                                  : Colors.grey,
                                            ),
                                            addHorizontalySpace(6),
                                            Text(
                                              paymentList[i],
                                              style: bodyText15normal(
                                                  color:
                                                      black.withOpacity(0.6)),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            CustomTextField(
                                hintText: "Amount Paid",
                                controller: amountPaidController,
                                textType: TextInputType.number,
                                onchanged: (value) {
                                  if (value.toString().isEmpty) {
                                    setState(() {
                                      paid = 0.0;
                                      due = billAmount;
                                      amountDueController.text = due.toString();
                                    });
                                  } else {
                                    paid = double.parse(value);
                                    setState(() {
                                      due = billAmount - paid;
                                      amountDueController.text = due.toString();
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Amount Paid';
                                  }
                                  return null;
                                }),
                            CustomTextField(
                                hintText: "Amount Due",
                                enabled: false,
                                controller: amountDueController,
                                textType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Amount Due';
                                  }
                                  return null;
                                }),
                            CustomTextField(
                              hintText: "Description",
                              controller: descriptionController,
                            ),
                            CustomButton(
                                text:
                                    widget.isEdit! ? "Edit Details" : "Cash In",
                                onClick: () async {
                                  if (!(double.parse(amountPaidController.text
                                          .toString()) <=
                                      double.parse(billAmountController.text
                                          .toString()))) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Amount Paid cannot be more than Bill Amount!");
                                  } else {
                                    if (widget.isEdit == true) {
                                      if (_formKey.currentState!.validate()) {
                                        print("edit!");

                                        DateTime incomeDate = DateTime.now();
                                        List date = dateController.text
                                            .toString()
                                            .split("/");
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
                                          incomeDate =
                                              DateTime.utc(year, month, day);
                                        });

                                        if (batchType == "Chicken") {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.owner)
                                              .collection("Batches")
                                              .doc(batchDocIds[widget.index])
                                              .get()
                                              .then((value) {
                                            setState(() {
                                              noChicks = int.parse(value
                                                      .data()!["NoOfBirds"]
                                                      .toString()) -
                                                  int.parse(value
                                                      .data()!["Mortality"]
                                                      .toString()) -
                                                  int.parse(value
                                                      .data()!["Sold"]
                                                      .toString());
                                            });
                                          });

                                          print(noChicks);

                                          if (noChicks > 0 &&
                                              noChicks >= quantity) {
                                            await addIncomeDetailsToFirestore();
                                            if (quantity != soldBefore) {
                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(widget.owner)
                                                  .collection("Batches")
                                                  .doc(
                                                      batchDocIds[widget.index])
                                                  .set({
                                                "Sold": FieldValue.increment(
                                                    quantity),
                                              }, SetOptions(merge: true));
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Stock not available!");
                                          }
                                        }
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.owner)
                                            .collection("Batches")
                                            .doc(batchDocIds[widget.index])
                                            .collection("BatchData")
                                            .doc("Income")
                                            .set(
                                          {
                                            "incomeDetails": widget.upto! +
                                                [
                                                  {
                                                    "date":
                                                        DateFormat("dd/MM/yyyy")
                                                            .format(incomeDate),
                                                    'name': nameController.text
                                                        .toString(),
                                                    'Rate': rate,
                                                    'Contact': contactController
                                                        .text
                                                        .toString(),
                                                    'IncomeCategory': batchType,
                                                    'Quantity': quantity,
                                                    'Weight': weight,
                                                    'BillAmount': billAmount,
                                                    'PaymentMethod':
                                                        paymentList[
                                                            selectedIndex],
                                                    'AmountPaid': paid,
                                                    'AmountDue': due,
                                                    "CostPerBird":
                                                        widget.updatedPrice,
                                                    'Description':
                                                        descriptionController
                                                            .text
                                                            .toString(),
                                                  },
                                                ] +
                                                widget.after!,
                                          },
                                        );

                                        List customers = [];

                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection("settings")
                                            .doc("Customer List")
                                            .get()
                                            .then((value) {
                                          if (value.exists) {
                                            setState(() {
                                              customers = value["customerList"];
                                            });
                                          }
                                        });

                                        for (int i = 0;
                                            i < customers.length;
                                            i++) {
                                          if (customers[i]["contact"] ==
                                                  "+91 ${contactController.text.toString()}" &&
                                              customers[i]["name"] ==
                                                  nameController.text
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Customer already exists!");
                                          } else {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("settings")
                                                .doc("Customer List")
                                                .set({
                                              "customerList":
                                                  FieldValue.arrayUnion([
                                                {
                                                  "name": nameController.text
                                                      .toString(),
                                                  "contact":
                                                      "+91 ${contactController.text.toString()}",
                                                }
                                              ]),
                                            }, SetOptions(merge: true));
                                          }
                                        }

                                        Fluttertoast.showToast(
                                            msg:
                                                "Details updated successfully!");

                                        Navigator.pop(context, true);
                                      }
                                    } else {
                                      print(dateController.text.toString());
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Processing Data')),
                                        );

                                        if (batchType == "Chicken") {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.owner)
                                              .collection("Batches")
                                              .doc(batchDocIds[widget.index])
                                              .get()
                                              .then((value) {
                                            setState(() {
                                              noChicks = int.parse(value
                                                      .data()!["NoOfBirds"]
                                                      .toString()) -
                                                  int.parse(value
                                                      .data()!["Mortality"]
                                                      .toString()) -
                                                  int.parse(value
                                                      .data()!["Sold"]
                                                      .toString());
                                            });
                                          });

                                          print(noChicks);

                                          if (noChicks > 0 &&
                                              noChicks >= quantity) {
                                            await addIncomeDetailsToFirestore();
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.owner)
                                                .collection("Batches")
                                                .doc(batchDocIds[widget.index])
                                                .set({
                                              "Sold": FieldValue.increment(
                                                  quantity),
                                            }, SetOptions(merge: true));
                                            Navigator.pop(context, true);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Stock not available!");
                                          }
                                        } else {
                                          await addIncomeDetailsToFirestore();
                                          Navigator.pop(context, true);
                                        }
                                      }
                                    }
                                  }
                                },
                                width: width(context),
                                height: 55)
                          ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> addIncomeDetailsToFirestore() async {
    DateTime incomeDate = DateTime.now();
    List date = dateController.text.toString().split("/");
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
      incomeDate = DateTime.utc(year, month, day);
    });

    print(updatedPrice);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(batchDocIds[widget.index])
        .collection("BatchData")
        .doc("Income")
        .set(
      {
        "incomeDetails": FieldValue.arrayUnion(
          [
            {
              "date": DateFormat("dd/MM/yyyy").format(incomeDate),
              'name': nameController.text.toString(),
              'Rate': rate,
              'Contact': contactController.text.toString(),
              'IncomeCategory': batchType,
              'Quantity': quantity,
              'Weight': weight,
              'BillAmount': billAmount,
              "CostPerBird": updatedPrice,
              'PaymentMethod': paymentList[selectedIndex],
              'AmountPaid': paid,
              'AmountDue': due,
              'Description': descriptionController.text.toString(),
            },
          ],
        ),
      },
      SetOptions(merge: true),
    );

    List customers = [];

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("settings")
        .doc("Customer List")
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          customers = value["customerList"];
        });
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("settings")
            .doc("Customer List")
            .set({
          "customerList": [],
        });
      }
    });

    print("Customer List: $customers");
    int addedCheck = 0;
    for (int i = 0; i < customers.length; i++) {
      if (customers[i]["contact"] ==
              "+91 ${contactController.text.toString()}" &&
          customers[i]["name"] == nameController.text.toString()) {
        Fluttertoast.showToast(msg: "Customer already exists!");
      } else {
        setState(() {
          addedCheck += 1;
        });
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("settings")
            .doc("Customer List")
            .set({
          "customerList": FieldValue.arrayUnion([
            {
              "name": nameController.text.toString(),
              "contact": "+91 ${contactController.text.toString()}",
            }
          ]),
        }, SetOptions(merge: true));
      }
    }
    if (addedCheck == 0) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("settings")
          .doc("Customer List")
          .set({
        "customerList": FieldValue.arrayUnion([
          {
            "name": nameController.text.toString(),
            "contact": "+91 ${contactController.text.toString()}",
          }
        ]),
      }, SetOptions(merge: true));
    }
  }
}
