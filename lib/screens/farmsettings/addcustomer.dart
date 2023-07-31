import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

TextEditingController nameController = TextEditingController();
TextEditingController numberController = TextEditingController();

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});
  @override
  AddCustomerState createState() => AddCustomerState();
}

class AddCustomerState extends State<AddCustomer> {
  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    numberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Customer",
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) * 0.88,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    addVerticalSpace(20),
                    CustomTextField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                    CustomTextField(
                      hintText: "Contact Number",
                      controller: numberController,
                      textType: TextInputType.number,
                    ),
                  ],
                ),
                CustomButton(
                    text: "Add",
                    onClick: () async {
                      if (nameController.length == 0 ||
                          numberController.length != 10) {
                        Fluttertoast.showToast(
                            msg: "Please enter name or Number!");
                      } else {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("settings")
                            .doc("Customer List")
                            .set({
                          "customerList": FieldValue.arrayUnion([
                            {
                              "name": nameController.text.toString(),
                              "contact":
                                  "+91 ${numberController.text.toString()}",
                            }
                          ]),
                        }, SetOptions(merge: true));

                        Fluttertoast.showToast(msg: "Data Added Successfully!");

                        Navigator.pop(context, true);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
