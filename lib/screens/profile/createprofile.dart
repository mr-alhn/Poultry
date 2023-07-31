import 'dart:async';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/auth/login.dart';
import 'package:poultry_app/screens/bottomnav.dart';
import 'package:poultry_app/screens/profile/editprofile.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/navigation.dart';
import '../../widgets/customdropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfilePage extends StatefulWidget {
  final controller = TextEditingController();
  final bool usingPhoneNumber;
  String? name;
  String? email;
  CreateProfilePage({
    super.key,
    required this.usingPhoneNumber,
    this.name,
    this.email,
  });

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  void pickUpImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 75);
  }

  @override
  void initState() {
    super.initState();
    print(widget.usingPhoneNumber);
    setState(() {
      userController.text = widget.name ?? "";
      emailController.text = widget.email ?? "";
    });
  }

  final userController = TextEditingController();
  final emailController = TextEditingController();
  final farmnameController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final villageController = TextEditingController();
  final capacityController = TextEditingController();
  final farmController = TextEditingController();
  final phoneController = TextEditingController();

  var user = FirebaseAuth.instance.currentUser?.uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String type = "";

  final fireStore = FirebaseFirestore.instance.collection('users');
  List list = ["Broiler", "Deshi", "Layer", "Breeder Farm"];

  @override
  Widget build(BuildContext context) {
    CustomDropdown customDropdown = CustomDropdown(
      list: list,
      height: 58,
      hint: "Farm",
      // index: curIndex,
      // controller: farmController,
      value: farmController.text.toString(),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        foregroundColor: black,
        title: Text(
          "Create Profile",
          style: bodyText18w600(color: black),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            Column(
              children: [
                addVerticalSpace(10),
                SizedBox(
                  height: 80,
                  width: 85,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: white,
                        radius: 40,
                        backgroundImage:
                            const AssetImage("assets/images/profile.png"),
                      ),
                      Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: GestureDetector(
                              onTap: () {
                                NextScreen(context, const EditProfilePage());
                              },
                              child: CircleAvatar(
                                  backgroundColor: yellow,
                                  radius: 14,
                                  child: Icon(
                                    Icons.edit,
                                    size: 17,
                                    color: white,
                                  )),
                            ),
                          ))
                    ],
                  ),
                ),
                addVerticalSpace(10),
                Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomTextField(
                        hintText: "Name",
                        controller: userController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                          hintText: "Email",
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter valid Email';
                            }
                            return null;
                          }),
                      widget.usingPhoneNumber
                          ? Container()
                          : CustomTextField(
                              hintText: "Phone Number",
                              controller: phoneController,
                              validator: (value) {
                                if (value == null || value.length != 10) {
                                  return 'Enter valid phoneNumber';
                                }
                                return null;
                              },
                            ),
                      CustomTextField(
                          hintText: "Farm Name",
                          controller: farmnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Farm Name';
                            }
                            return null;
                          }),
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
                        onCountryChanged: (country) {
                          countryValue = country;
                        },
                        onStateChanged: (state) {
                          stateValue = state;
                        },
                        onCityChanged: (city) {
                          cityValue = city;
                        },
                      ),
                      addVerticalSpace(10),
                      CustomTextField(
                          hintText: "Farm Capacity",
                          controller: capacityController,
                          textType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Farm Capacity';
                            }
                            return null;
                          }),
                      CustomDropdown(
                        list: list,
                        height: 58,
                        hint: "Farm",
                        // index: curIndex,
                        // controller: farmController,
                        onchanged: (value) {
                          setState(() {
                            type = value;
                          });
                        },
                        value: farmController.text.toString(),
                      ),
                    ]))
              ],
            ),
            addVerticalSpace(10),
            CustomButton(
                height: 55,
                width: width(context),
                text: "Register",
                onClick: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    await users.doc(_auth.currentUser!.uid).set({
                      'name': userController.text.toString(),
                      'email': emailController.text.toString(),
                      'phone': widget.usingPhoneNumber
                          ? phone.text.toString()
                          : phoneController.text.toString(),
                      'Type': type,
                      'State': stateValue,
                      'FarmName': farmnameController.text.toString(),
                      'Farm Capacity': capacityController.text.toString(),
                      'Country': countryValue,
                      'City': cityValue,
                    });

                    print(user);

                    showDialog(
                        context: context,
                        builder: (context) => const ShowDialogBox(
                            message: "Profile Created!",
                            subMessage:
                                "Your profile has been created\nsuccessfully."));
                    Timer(const Duration(seconds: 4),
                        () => NextScreen(context, const BottomNavigation()));
                  }
                  // showDialog(
                  //     context: context,
                  //     builder: (context) => const ShowDialogBox(
                  //         message: "Profile Created!",
                  //         subMessage:
                  //             "Your profile has been created\n successfully."));
                  // Timer(const Duration(seconds: 4),
                  //     () => NextScreen(context,  const BottomNavigation()));
                }),
          ]),
        ),
      ),
    );
  }
}
