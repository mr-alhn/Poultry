import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/quantitybutton.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  List availableOrders = [];
  List orderDetails = [];
  int quantity = 0; //get quantity from backend
  int index = -1;
  String selectedValue = "";
  String bagLoc = "Stock Room"; //edit later maybe?
  // int value = 1;
  TextEditingController feedTypeController = TextEditingController();
  TextEditingController feedCompanyController = TextEditingController();
  TextEditingController feedWeightController = TextEditingController();
  TextEditingController feedPriceController = TextEditingController();
  TextEditingController feedTotalController = TextEditingController();

  Future<void> getAvailableOrders() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          for (int i = 0; i < value.data()!.length; i++) {
            // print(value.data()?["order${i + 1}"]);
            if (value.data()?["order${i + 1}"]["orderStatus"] != "Completed") {
              setState(() {
                availableOrders.add("order${i + 1}");
                orderDetails.add({
                  "feedType": value.data()?["order${i + 1}"]["feedType"],
                  "feedCompany": value.data()?["order${i + 1}"]["feedCompany"],
                  "feedWeight": value.data()?["order${i + 1}"]["feedWeight"],
                  "feedQuantity": value.data()?["order${i + 1}"]
                      ["feedQuantity"],
                  "originalQuantity": value.data()?["order${i + 1}"]
                      ["originalQuantity"],
                  "feedPrice": value.data()?["order${i + 1}"]["feedPrice"],
                  "totalPrice": value.data()?["order${i + 1}"]["totalPrice"],
                });
              });
            }
          }
        });
        print(availableOrders);
        print(orderDetails);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAvailableOrders();
  }

  @override
  Widget build(BuildContext context) {
    final QuantityButton quantityButton = QuantityButton(
      canIncrease: false,
      totalQuantity: quantity,
      current: quantity,
    );
    final CustomDropdown customDropdown = CustomDropdown(
      list: availableOrders,
      height: 58,
      hint: "Order No.",
      iconSize: 25,
      onchanged: (value) {
        setState(() {
          index = availableOrders.indexOf(value);
          selectedValue = value;
        });
        setState(() {
          feedTypeController.text = orderDetails[index]["feedType"];
          feedCompanyController.text = orderDetails[index]["feedCompany"];
          feedWeightController.text = "${orderDetails[index]["feedWeight"]} KG";
          quantity = int.parse(orderDetails[index]["feedQuantity"].toString());
          feedPriceController.text =
              orderDetails[index]["feedPrice"].toString();
          feedTotalController.text =
              orderDetails[index]["totalPrice"].toString();
        });
      },
    );

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Inventory",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              addVerticalSpace(15),
              customDropdown,
              CustomTextField(
                hintText: "Feed Type",
                enabled: false,
                controller: feedTypeController,
              ),
              CustomTextField(
                hintText: "Feed Company",
                enabled: false,
                controller: feedCompanyController,
              ),
              CustomTextField(
                hintText: "Bag Weight",
                enabled: false,
                controller: feedWeightController,
              ),
              quantityButton,
              CustomTextField(
                hintText: "Bag Price",
                enabled: false,
                controller: feedPriceController,
              ),
              CustomTextField(
                hintText: "Total",
                enabled: false,
                controller: feedTotalController,
              ),
              addVerticalSpace(60),
              CustomButton(
                  text: "Feed Received",
                  onClick: () async {
                    int current = quantityButton.current;
                    if (current != 0) {
                      await FirebaseFirestore.instance
                          .collection('inventory')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set(
                        {
                          selectedValue: {
                            "feedType": orderDetails[index]["feedType"],
                            "feedCompany": orderDetails[index]["feedCompany"],
                            "feedQuantity": FieldValue.increment(current),
                            "bagLocation": bagLoc,
                            "originalQuantity": FieldValue.increment(current),
                            "feedPrice": orderDetails[index]["feedPrice"],
                          }
                        },
                        SetOptions(merge: true),
                      );

                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        selectedValue: {
                          "feedQuantity": quantity - quantityButton.current,
                          "orderStatus": quantity - quantityButton.current == 0
                              ? "Completed"
                              : "Partially Received",
                        }
                      }, SetOptions(merge: true));

                      showDialog(
                          context: context,
                          builder: (context) => const ShowDialogBox(
                                message: "Feed Received!!",
                                subMessage: '',
                              ));
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Feed received cannnot be 0");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
