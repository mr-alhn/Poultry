import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/farmsettings/addfeedtype.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class AddOrderPage extends StatefulWidget {
  bool? isEdit = false;
  String? orderNo;
  String? feedSelected;
  String? company;
  String? size;
  int? quantity;
  String? date;
  double? price;
  double? total;
  String? paymentMethod;
  int? batchIndex;

  AddOrderPage({
    super.key,
    this.isEdit,
    this.orderNo,
    this.feedSelected,
    this.company,
    this.date,
    this.size,
    this.quantity,
    this.price,
    this.total,
    this.paymentMethod,
    this.batchIndex,
  });

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

int orderNo = 1;
int quantity = 0;
double price = 0.0;
double total = 0.0;

class _AddOrderPageState extends State<AddOrderPage> {
  List feedType = [];
  String type = "";
  final date = TextEditingController(
      text: DateFormat("dd/MMM/yyyy")
          .format(DateTime.now())
          .toString()
          .toLowerCase());
  TextEditingController companyController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      setState(() {
        orderNo = int.parse(widget.orderNo!);
        date.text = widget.date!;
        type = widget.feedSelected!;
        companyController.text = widget.company!;
        weightController.text = widget.size!;
        quantityController.text = widget.quantity.toString();
        quantity = int.parse(widget.quantity.toString());
        price = double.parse(widget.price.toString());
        totalController.text = widget.total.toString();
        total = double.parse(widget.total.toString());
        priceController.text = widget.price.toString();
        option = widget.paymentMethod == "Cash" ? false : true;
      });
    } else {
      getOrderNumber();
      getFeedType();
    }
  }

  Future<void> getOrderNumber() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (value) {
        if (value.exists) {
          //orders exist for the user
          int data = value.data()!.length + 1;
          setState(() {
            orderNo = data;
          });
        } else {
          setState(() {
            orderNo = 1;
          });
        }
      },
    );
    print(orderNo);
  }

  Future<void> getFeedType() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('settings')
        .doc('Feed Type')
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          feedType = value.data()?['feedType'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    companyController.dispose();
    date.dispose();
    quantityController.dispose();
    priceController.dispose();
    totalController.dispose();
    weightController.dispose();
  }

  bool option = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Order",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 27,
                width: 93,
                decoration: shadowDecoration(6, 0, yellow),
                child: Center(
                  child: Text(
                    "Order No. $orderNo",
                    style: bodyText10w600(color: white),
                  ),
                ),
              ),
              CustomTextField(
                hintText: "Date",
                suffix: true,
                controller: date,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      list: feedType,
                      height: 58,
                      hint: type.isEmpty ? "Feed Type" : type,
                      onchanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                  ),
                  addHorizontalySpace(15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AddFeedType())).then((value) {
                        if (value == null) {
                          return;
                        } else {
                          if (value) {
                            getFeedType();
                          }
                        }
                      });
                    },
                    child: Container(
                      height: 58,
                      width: 58,
                      decoration: shadowDecoration(10, 0, yellow),
                      child: Icon(
                        Icons.add,
                        size: 28,
                        color: white,
                      ),
                    ),
                  )
                ],
              ),
              CustomTextField(
                hintText: "Feed Company",
                controller: companyController,
              ),
              CustomTextField(
                hintText: "Bag Size in KG (Ex. 50)",
                controller: weightController,
                textType: TextInputType.number,
              ),
              CustomTextField(
                hintText: "Bag Quantity",
                controller: quantityController,
                textType: TextInputType.number,
                onchanged: (value) {
                  setState(() {
                    if (value.toString().isNotEmpty) {
                      setState(() {
                        quantity = int.tryParse(value.toString())!;
                        total = price * quantity;
                      });
                      print(quantity);
                    } else {
                      setState(() {
                        quantity = 0;
                        total = 0;
                      });
                      print(quantity);
                    }
                    totalController.text = total.toString();
                  });
                },
              ),
              CustomTextField(
                hintText: "Bag Price",
                controller: priceController,
                textType: TextInputType.number,
                onchanged: (value) {
                  setState(() {
                    if (value.toString().isNotEmpty) {
                      price = double.tryParse(value.toString())!;
                      total = price * quantity;
                    } else {
                      setState(() {
                        price = 0.0;
                        total = 0.0;
                      });
                    }
                    totalController.text = total.toString();
                  });
                },
              ),
              CustomTextField(
                hintText: "Total",
                enabled: false,
                controller: totalController,
              ),
              addVerticalSpace(10),
              Text(
                "Payment Method",
                style: bodyText15w500(color: darkGray),
              ),
              addVerticalSpace(20),
              Row(
                children: [
                  Text(
                    "Cash",
                    style: bodyText15w500(color: darkGray),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FlutterSwitch(
                      padding: 3,
                      value: option,
                      inactiveColor: yellow,
                      activeColor: yellow,
                      onToggle: (value) {
                        setState(() {
                          option = value;
                        });
                      },
                      width: 50,
                      height: 25,
                      toggleSize: 20,
                    ),
                  ),
                  Text(
                    "Online",
                    style: bodyText15w500(color: black),
                  ),
                ],
              ),
              addVerticalSpace(15),
              CustomButton(
                  text: "Place Order",
                  onClick: () async {
                    if (widget.isEdit == true) {
                      Map<String, dynamic> upto = {};
                      Map<String, dynamic> current = {};
                      Map<String, dynamic> after = {};

                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) {
                        if (value.exists) {
                          // print(value.data()!["order1"]["date"]);
                          for (int i = 0; i <= value.data()!.length - 1; i++) {
                            if (i < widget.batchIndex!) {
                              upto["order${i + 1}"] = {
                                "date": value.data()!["order${i + 1}"]["date"],
                                "feedType": value.data()!["order${i + 1}"]
                                    ["feedType"],
                                "feedCompany": value.data()!["order${i + 1}"]
                                    ["feedCompany"],
                                "feedWeight": int.parse(value
                                    .data()!["order${i + 1}"]["feedWeight"]
                                    .toString()),
                                "feedQuantity": int.parse(value
                                    .data()!["order${i + 1}"]["feedQuantity"]
                                    .toString()),
                                "originalQuantity": int.parse(value
                                    .data()!["order${i + 1}"]
                                        ["originalQuantity"]
                                    .toString()),
                                "feedPrice": double.parse(value
                                    .data()!["order${i + 1}"]["feedPrice"]
                                    .toString()),
                                "totalPrice": double.parse(value
                                    .data()!["order${i + 1}"]["totalPrice"]
                                    .toString()),
                                "orderStatus": value.data()!["order${i + 1}"]
                                    ["orderStatus"],
                                "paymentMethod": value.data()!["order${i + 1}"]
                                    ["paymentMethod"],
                              };
                            } else if (i == widget.batchIndex) {
                              current["order${i + 1}"] = {
                                "date": date.text,
                                "feedType": type,
                                "feedCompany": companyController.text,
                                "feedWeight": int.parse(weightController.text),
                                "feedQuantity": quantity,
                                "originalQuantity": quantity,
                                "feedPrice": price,
                                "totalPrice": total,
                                "orderStatus": "Not Received",
                                "paymentMethod":
                                    option == true ? "Online" : "Cash",
                              };
                            } else {
                              after["order${i + 1}"] = {
                                "date": value.data()!["order${i + 1}"]["date"],
                                "feedType": value.data()!["order${i + 1}"]
                                    ["feedType"],
                                "feedCompany": value.data()!["order${i + 1}"]
                                    ["feedCompany"],
                                "feedWeight": int.parse(value
                                    .data()!["order${i + 1}"]["feedWeight"]
                                    .toString()),
                                "feedQuantity": int.parse(value
                                    .data()!["order${i + 1}"]["feedQuantity"]
                                    .toString()),
                                "originalQuantity": int.parse(value
                                    .data()!["order${i + 1}"]
                                        ["originalQuantity"]
                                    .toString()),
                                "feedPrice": double.parse(value
                                    .data()!["order${i + 1}"]["feedPrice"]
                                    .toString()),
                                "totalPrice": double.parse(value
                                    .data()!["order${i + 1}"]["totalPrice"]
                                    .toString()),
                                "orderStatus": value.data()!["order${i + 1}"]
                                    ["orderStatus"],
                                "paymentMethod": value.data()!["order${i + 1}"]
                                    ["paymentMethod"],
                              };
                            }
                          }
                        }
                      });

                      Map<String, dynamic> updatedMap = {};
                      updatedMap.addAll(upto);
                      updatedMap.addAll(current);
                      updatedMap.addAll(after);

                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set(updatedMap);

                      Fluttertoast.showToast(msg: "Data updated successfully!");

                      Navigator.pop(context, true);
                    } else {
                      print(option);
                      if (date.text.isEmpty ||
                          type.isEmpty ||
                          companyController.text.isEmpty ||
                          weightController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please fill all the details!");
                      } else {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set(
                          {
                            "order$orderNo": {
                              "date": date.text,
                              "feedType": type,
                              "feedCompany": companyController.text,
                              "feedWeight": int.tryParse(weightController.text),
                              "feedQuantity": quantity,
                              "originalQuantity": quantity,
                              "feedPrice": price,
                              "totalPrice": total,
                              "orderStatus": "Not Received",
                              "paymentMethod":
                                  option == true ? "Online" : "Cash",
                            }
                          },
                          SetOptions(merge: true),
                        );
                        print(type);
                        // print({
                        //   "date": date.text,
                        //   "feedType": _customDropdown.value,
                        //   "feedCompany": companyController.text,
                        //   "feedWeight": double.tryParse(weightController.text),
                        //   "feedQuantity": quantity,
                        //   "feedPrice": price,
                        //   "totalPrice": total,
                        //   "paymentMethod": option == true ? "Online" : "Cash",
                        // });
                        showDialog(
                            context: context,
                            builder: (context) => const ShowDialogBox(
                                  message: "Order Placed!!",
                                  subMessage: '',
                                ));
                      }
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
