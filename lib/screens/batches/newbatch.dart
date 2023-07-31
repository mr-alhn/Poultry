import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';


class NewBatch extends StatefulWidget {
  bool? isEdit = false;
  String? docId = "abc";
  String? owner = "def";
  NewBatch(
      {super.key, required this.title, this.isEdit, this.owner, this.docId});
  final String title;

  @override
  State<NewBatch> createState() => _NewBatchState();
}

var user = FirebaseAuth.instance.currentUser?.uid;

class _NewBatchState extends State<NewBatch> {
  final _formKey = GlobalKey<FormState>();

  List breed = ["Broiler", "Deshi", "Layer", "Breeder Farm"];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String selectedValue = "";
  bool isLoading = false;

  final dateController = TextEditingController(
      text: DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase());
  final BatchNameController = TextEditingController();
  final BreedController = TextEditingController();
  final NoOfBirdsController = TextEditingController();
  final CostPerBirdController = TextEditingController();
  final SupplierController = TextEditingController();

  final fireStore = FirebaseFirestore.instance
      .collection('users')
      .doc(user)
      .collection('Batches');

  Future<void> getDetailsFromFirestore() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.docId)
        .get()
        .then((value) {
      BatchNameController.text = value.data()!["BatchName"];
      dateController.text = value.data()!["date"];
      selectedValue = value.data()!["Breed"];
      NoOfBirdsController.text = value.data()!["NoOfBirds"].toString();
      // CostPerBirdController.text = value.data()!["CostPerBird"];
      SupplierController.text = value.data()!["Supplier"];
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      getDetailsFromFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: GeneralAppBar(
          islead: true,
          bottom: true,
          title: widget.title,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) - 135,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: "Date",
                              suffix: true,
                              controller: dateController,
                              canSelectBefore: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Date';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: "Batch Name",
                              controller: BatchNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Batch Name';
                                }
                                return null;
                              },
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
                                                selectedValue != ""
                                                    ? selectedValue
                                                    : "Breed",
                                                style: bodyText16normal(
                                                    color: darkGray),
                                              ),
                                              style: bodyText15normal(
                                                  color: black),
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
                                                  selectedValue = value!;
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
                              hintText: "Number of birds",
                              controller: NoOfBirdsController,
                              textType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Amount of Birds';
                                }
                                return null;
                              },
                            ),
                            // CustomTextField(
                            //   hintText: "Cost per bird",
                            //   controller: CostPerBirdController,
                            //   textType: TextInputType.number,
                            //   validator: (value) {
                            //     if (value == null || value.length == 0) {
                            //       return 'Enter Cost per Bird';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            CustomTextField(
                              hintText: "Supplier",
                              controller: SupplierController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Supplier Name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: "Submit",
                        onClick: () async {
                          //
                          // fetchData();
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            // print(BreedController.text.toString());
                            print(selectedValue);
                            if (widget.isEdit == false) {
                              print('executing');
                              DocumentReference newBatchDoc = fireStore.doc();
                              await newBatchDoc.set({
                                'date': dateController.text.toString(),
                                'BatchName':
                                    BatchNameController.text.toString(),
                                'Breed': selectedValue,
                                'NoOfBirds': int.parse(
                                    NoOfBirdsController.text.toString()),
                                // 'CostPerBird':
                                //     CostPerBirdController.text.toString(),
                                'Supplier': SupplierController.text.toString(),
                                "Sold": 0,
                                "Mortality": 0,
                                "active": true, //for open and close batch!
                              });
                              print(newBatchDoc.id);
                              await FirebaseFirestore.instance
                                  .collection('batches')
                                  .doc(newBatchDoc.id)
                                  .set(
                                {
                                  "owner":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "userIDs": []
                                },
                                SetOptions(merge: true),
                              );
                            } else {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.owner)
                                  .collection("Batches")
                                  .doc(widget.docId)
                                  .set(
                                {
                                  'date': dateController.text.toString(),
                                  'BatchName':
                                      BatchNameController.text.toString(),
                                  'Breed': selectedValue,
                                  'NoOfBirds': int.parse(
                                      NoOfBirdsController.text.toString()),
                                  // 'CostPerBird':
                                  //     CostPerBirdController.text.toString(),
                                  'Supplier':
                                      SupplierController.text.toString(),
                                },
                                SetOptions(merge: true),
                              );
                            }
                            Future.delayed(const Duration(milliseconds: 1000), () {
                              if (widget.isEdit == true) {
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pop(context, true);
                              }
                            });
                          }
                        },
                        width: width(context),
                        height: 55,
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// void fetchData() async {
//   BatchName.clear();
//   print(BatchName);
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final querySnapshot = await firestore.collection('users').doc(
//       user.toString()).collection("Batches").get();
//   querySnapshot.docs.forEach((doc) {
//     //print("int " + doc.get("BatchName").toString());
//     Bname = doc.get("BatchName").toString();
//     BatchName.add(Bname);
//
//   });
//   print(Bname);
//   }
