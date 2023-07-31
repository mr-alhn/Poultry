import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class AddChickFeedReq extends StatefulWidget {
  bool? isEdit = false;
  String? day;
  String? breedSelected;
  String? grams;
  List? upto;
  List? after;

  AddChickFeedReq({
    super.key,
    this.isEdit,
    this.day,
    this.breedSelected,
    this.grams,
    this.upto,
    this.after,
  });

  @override
  State<AddChickFeedReq> createState() => _AddChickFeedReqState();
}

class _AddChickFeedReqState extends State<AddChickFeedReq> {
  List breed = ["Broiler", "Deshi", "Layer", "Breeder Farm"];
  List feedTypeList = [];
  TextEditingController dayController = TextEditingController();
  TextEditingController gramsController = TextEditingController();
  String breedSelected = "";

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      setState(() {
        dayController.text = widget.day!;
        gramsController.text = widget.grams!;
        breedSelected = widget.breedSelected!;
        breed = [];
      });
    } else {
      setState(() {
        breed = ["Broiler", "Deshi", "Layer", "Breeder Farm"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Chick Feed Requirement",
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) - 135,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    addVerticalSpace(20),
                    CustomTextField(
                      hintText: "Day",
                      textType: TextInputType.number,
                      controller: dayController,
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        height: 55,
                        width: width(context),
                        decoration: shadowDecoration(
                          10,
                          0,
                          tfColor,
                          bcolor: normalGray,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            height: height(context) * 0.04,
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton(
                                      icon: Icon(
                                        CupertinoIcons.chevron_down,
                                        size: 18,
                                        color: gray,
                                      ),
                                      hint: Text(
                                        breedSelected.isNotEmpty
                                            ? breedSelected
                                            : "Breed Type",
                                        style:
                                            bodyText16normal(color: darkGray),
                                      ),
                                      style: bodyText15normal(color: black),
                                      dropdownColor: white,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      items: breed.map((e) {
                                        return DropdownMenuItem(
                                            value: e.toString(),
                                            child: Text(e.toString()));
                                      }).toList(),
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          breedSelected = value!;
                                        });

                                        // print(widget.value);
                                        // print(widget.value);
                                      }),
                                ),
                              ],
                            ),
                          ),
                        )),
                    CustomTextField(
                      hintText: "Grams",
                      textType: TextInputType.number,
                      controller: gramsController,
                    ),
                  ],
                ),
                CustomButton(
                  text: "Add",
                  onClick: () async {
                    if (widget.isEdit == true) {
                      if (gramsController.text.toString().isNotEmpty &&
                          dayController.text.toString().isNotEmpty &&
                          breedSelected.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("settings")
                            .doc("Chick Feed Requirement")
                            .set({
                          breedSelected: widget.upto! +
                              [
                                {
                                  "day": dayController.text.toString(),
                                  "grams": gramsController.text.toString(),
                                }
                              ] +
                              widget.after!,
                        }, SetOptions(merge: true));
                        await FirebaseFirestore.instance
                            .collection("chickfeed")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          breedSelected: FieldValue.arrayUnion([
                            {
                              "day": dayController.text.toString(),
                              "grams": gramsController.text.toString(),
                            }
                          ]),
                        }, SetOptions(merge: true));

                        Fluttertoast.showToast(
                            msg: "Data Updated Successfully!");

                        Navigator.pop(context, true);
                      }
                    } else {
                      if (gramsController.text.toString().isNotEmpty &&
                          dayController.text.toString().isNotEmpty &&
                          breedSelected.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("settings")
                            .doc("Chick Feed Requirement")
                            .set({
                          breedSelected: FieldValue.arrayUnion([
                            {
                              "day": dayController.text.toString(),
                              "grams": gramsController.text.toString(),
                            }
                          ]),
                        }, SetOptions(merge: true));
                        await FirebaseFirestore.instance
                            .collection("chickfeed")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          breedSelected: FieldValue.arrayUnion([
                            {
                              "day": dayController.text.toString(),
                              "grams": gramsController.text.toString(),
                            }
                          ]),
                        }, SetOptions(merge: true));

                        Fluttertoast.showToast(msg: "Data Added Successfully!");

                        Navigator.pop(context, true);
                      } else {
                        Fluttertoast.showToast(msg: "Error!");
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
