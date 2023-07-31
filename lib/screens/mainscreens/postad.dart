// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poultry_app/screens/farmsettings/userinfo.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:intl/intl.dart';

class PostAdPage extends StatefulWidget {
  final String? title;
  const PostAdPage({super.key, this.title});
  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List list = ["lorem ipsum", "lorem ipsum", "lorem ipsum", "lorem ipsum"];
  XFile? imagePicked;
  String posterName = "";
  String country = "";
  String village = "";
  String state = "";

  @override
  void initState() {
    getPosterDetails();
  }

  Future<void> getPosterDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        posterName = value.data()!["name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "Post Your Ad",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    widget.title ?? "",
                    style: bodyText18w600(color: black),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    bool? isCamera = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      child: const Text("Camera"),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      child: const Text("Gallery"),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ]),
                            ));

                    if (isCamera == null) return;

                    final ImagePicker picker = ImagePicker();
                    XFile? tempImage = await picker.pickImage(
                        source: isCamera
                            ? ImageSource.camera
                            : ImageSource.gallery);

                    setState(() {
                      imagePicked = tempImage;
                    });

                    // print(imagePicked!.path);
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [10, 5],
                    strokeWidth: 2,
                    color: darkGray,
                    radius: const Radius.circular(15),
                    child: SizedBox(
                      width: width(context),
                      height: width(context) * .35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 50,
                            color: darkGray,
                          ),
                          addVerticalSpace(10),
                          Text(
                            "Upload image",
                            style: bodyText12w500(color: darkGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                CustomTextField(
                    hintText: "Quantity",
                    controller: quantityController,
                    textType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter Quantity';
                      }
                      return null;
                    }),
                CustomTextField(
                  hintText: "Contact Number",
                  controller: contactController,
                  textType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return "Not a valid contact number";
                    }
                    return null;
                  },
                ),
                addVerticalSpace(10),
                CSCPicker(
                  dropdownDecoration: BoxDecoration(
                    color: const Color.fromRGBO(232, 236, 244, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  selectedItemStyle: bodyText15normal(color: black),
                  dropdownItemStyle: bodyText15normal(color: black),
                  searchBarRadius: 15,
                  defaultCountry: CscCountry.India,
                  onCountryChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      state = value ?? "";
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      city = value ?? "";
                    });
                  },
                ),
                addVerticalSpace(10),
                // CustomTextField(
                //     hintText: "State",
                //     controller: stateController,
                //     validator: (value) {
                //       if (value == null || value.trim().length == 0) {
                //         return 'Enter State';
                //       }
                //       return null;
                //     }),
                // Row(
                //   children: [
                //     Expanded(
                //       child: CustomTextField(
                //           hintText: "City",
                //           controller: cityController,
                //           validator: (value) {
                //             if (value == null || value.trim().length == 0) {
                //               return 'Enter City';
                //             }
                //             return null;
                //           }),
                //     ),
                addHorizontalySpace(20),
                CustomTextField(
                    hintText: "Village",
                    controller: villageController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter Village';
                      }
                      return null;
                    }),

                CustomTextField(
                  hintText: "Description",
                  controller: descriptionController,
                ),

                CustomButton(
                    text: "Post",
                    onClick: () async {
                      if (_formKey.currentState!.validate()) {
                        if (contactController.text.length != 10) {
                          Fluttertoast.showToast(
                              msg: "Invalid Contact Number!");
                        } else {
                          if (imagePicked == null) {
                            await FirebaseFirestore.instance
                                .collection("adsListing")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set(
                              {
                                "advertisementDetails": FieldValue.arrayUnion([
                                  {
                                    "contact":
                                        contactController.text.toString(),
                                    "quantity": int.parse(
                                        quantityController.text.toString()),
                                    "city": city,
                                    "village":
                                        villageController.text.toString(),
                                    "country": country,
                                    "state": state,
                                    "description":
                                        descriptionController.text.toString(),
                                    "imageUrl": null,
                                    "date": DateFormat("dd/MM/yyyy")
                                        .format(DateTime.now()),
                                    "type": widget.title,
                                  }
                                ]),
                              },
                              SetOptions(merge: true),
                            );
                          } else {
                            FirebaseStorage storage = FirebaseStorage.instance;

                            final reference = storage
                                .ref()
                                .child(
                                    "adsListing/${FirebaseAuth.instance.currentUser!.uid}")
                                .child(imagePicked!.path.split('/').last);

                            final UploadTask upload =
                                reference.putFile(File(imagePicked!.path));
                            await upload.whenComplete(() async {
                              final String downloadUrl =
                                  await reference.getDownloadURL();

                              await FirebaseFirestore.instance
                                  .collection("adsListing")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .set(
                                {
                                  "advertisementDetails":
                                      FieldValue.arrayUnion([
                                    {
                                      "contact":
                                          contactController.text.toString(),
                                      "quantity": int.parse(
                                          quantityController.text.toString()),
                                      "state": state,
                                      "city": city,
                                      "country": country,
                                      "village":
                                          villageController.text.toString(),
                                      "imageUrl": downloadUrl,
                                      "description":
                                          descriptionController.text.toString(),
                                      "sold": false,
                                      "date": DateFormat("dd/MM/yyyy")
                                          .format(DateTime.now()),
                                      "type": widget.title,
                                    }
                                  ]),
                                },
                                SetOptions(merge: true),
                              );
                            });
                          }
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const ShowDialogBox(message: "Ad Posted!!"));

                          Future.delayed(
                              const Duration(
                                seconds: 1,
                              ), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
                    width: width(context),
                    height: 55)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
