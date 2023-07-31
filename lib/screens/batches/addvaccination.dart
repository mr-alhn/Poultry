import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:intl/intl.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class AddVaccinationPage extends StatefulWidget {
  String docId;
  int? batchIndex;
  bool? isEdit = false;
  List? upto;
  List? after;
  String? name;
  String? type;
  String? method;
  String? description;
  String? date;
  String owner;
  AddVaccinationPage({
    super.key,
    required this.docId,
    required this.owner,
    this.name,
    this.type,
    this.method,
    this.description,
    this.date,
    this.isEdit = false,
    this.batchIndex,
    this.upto,
    this.after,
  });

  @override
  State<AddVaccinationPage> createState() => _AddVaccinationPageState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _AddVaccinationPageState extends State<AddVaccinationPage> {
  final fireStore = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection("Batches")
      .doc(user)
      .collection("AddVaccination");

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final vaccineController = TextEditingController();
  final vaccineTypeController = TextEditingController();
  final methodController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime batchDate = DateTime.utc(1800, 01, 01);

  Future<void> getBatchInformation() async {
    await FirebaseFirestore.instance
        .collection('users')
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
      });
    });
  }

  String vaccineName = "";
  String vaccineTypeString = "";
  String method = "";

  List vaccineMode = ['Live', 'Killed'];
  List vaccineType = [
    'MAREK\'S',
    'Newcastle Disease( ND) B1',
    'Newcastle Disease( ND) LaSota',
    'Newcastle Disease( ND) R2B',
    'Fow Pox',
    'Avian Infectious Bronchitis',
    'Infectious Bursal Disease (Gaumboro I+)',
    'Massachusetts Type H-120 Strain',
    'CORYZA',
  ];
  List vaccineMethod = ['Eye Drop', 'Drinking Water', 'SC', 'IM'];
  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      dateController.text = DateFormat("dd/MMM/yyyy")
          .format(DateFormat("dd/MM/yyyy").parse(widget.date!))
          .toLowerCase();
      vaccineName = widget.name!;
      vaccineTypeString = widget.type!;
      method = widget.method!;
      descriptionController.text = widget.description!;
    }
    getBatchInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(20),
                      Center(
                        child: Text(
                          "Add Vaccination",
                          style: bodyText22w600(color: black),
                        ),
                      ),
                      addVerticalSpace(20),
                      CustomTextField(
                        hintText: "Date",
                        suffix: true,
                        controller: dateController,
                        cannotSelectBefore: batchDate,
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          height: 55,
                          width: width(context),
                          decoration: shadowDecoration(
                            10,
                            0,
                            const Color.fromRGBO(232, 236, 244, 1),
                            bcolor: const Color.fromRGBO(232, 236, 244, 1),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
                                          vaccineName.isNotEmpty
                                              ? vaccineName
                                              : "Vaccine Mode",
                                          style:
                                              bodyText16normal(color: darkGray),
                                        ),
                                        style: bodyText15normal(color: black),
                                        dropdownColor: white,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        items: vaccineMode.map((e) {
                                          return DropdownMenuItem(
                                              value: e.toString(),
                                              child: Text(e.toString()));
                                        }).toList(),
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            vaccineName = value!;
                                          });

                                          // print(widget.value);
                                          // print(widget.value);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          height: 55,
                          width: width(context),
                          decoration: shadowDecoration(
                            10,
                            0,
                            const Color.fromRGBO(232, 236, 244, 1),
                            bcolor: const Color.fromRGBO(232, 236, 244, 1),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
                                          vaccineTypeString.isNotEmpty
                                              ? vaccineTypeString
                                              : "Vaccine Type",
                                          style:
                                              bodyText16normal(color: darkGray),
                                        ),
                                        style: bodyText15normal(color: black),
                                        dropdownColor: white,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        items: vaccineType.map((e) {
                                          return DropdownMenuItem(
                                              value: e.toString(),
                                              child: Text(e.toString()));
                                        }).toList(),
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            vaccineTypeString = value!;
                                          });

                                          // print(widget.value);
                                          // print(widget.value);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          height: 55,
                          width: width(context),
                          decoration: shadowDecoration(
                            10,
                            0,
                            const Color.fromRGBO(232, 236, 244, 1),
                            bcolor: const Color.fromRGBO(232, 236, 244, 1),
                          ),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
                                          method.isNotEmpty ? method : "Method",
                                          style:
                                              bodyText16normal(color: darkGray),
                                        ),
                                        style: bodyText15normal(color: black),
                                        dropdownColor: white,
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        items: vaccineMethod.map((e) {
                                          return DropdownMenuItem(
                                              value: e.toString(),
                                              child: Text(e.toString()));
                                        }).toList(),
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            method = value!;
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
                        hintText: "Description",
                        controller: descriptionController,
                      )
                    ]),
              ),
            ]),
            addVerticalSpace(height(context) * 0.22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomButton(
                  text: "Add",
                  onClick: () async {
                    if (widget.isEdit == true) {
                      Map current = {};

                      current.addAll({
                        "date": dateController.text.toString(),
                        "method": method,
                        "vaccineName": vaccineName,
                        "vaccineType": vaccineTypeString,
                        "Description": descriptionController.text.toString(),
                      });

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.owner)
                          .collection("Batches")
                          .doc(widget.docId)
                          .collection("BatchData")
                          .doc("Vaccination")
                          .set({
                        "vaccinationDetails":
                            widget.upto! + [current] + widget.after!,
                      });

                      Fluttertoast.showToast(msg: "Data updated successfully!");
                    } else {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.owner)
                          .collection("Batches")
                          .doc(widget.docId)
                          .collection("BatchData")
                          .doc("Vaccination")
                          .set({
                        "vaccinationDetails": FieldValue.arrayUnion([
                          {
                            'date': dateController.text.toString(),
                            'vaccineName': vaccineName,
                            'vaccineType': vaccineTypeString,
                            'method': method,
                            'Description':
                                descriptionController.text.toString(),
                          }
                        ])
                      }, SetOptions(merge: true));
                    }

                    Navigator.pop(context, true);
                  },
                  width: width(context),
                  height: 55),
            )
          ],
        ),
      ),
    );
  }
}
