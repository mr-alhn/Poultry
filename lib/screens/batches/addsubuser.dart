import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class AddSubUserPage extends StatefulWidget {
  final int index;
  String owner;
  AddSubUserPage({super.key, required this.index, required this.owner});

  @override
  State<AddSubUserPage> createState() => _AddSubUserPageState();
}

class _AddSubUserPageState extends State<AddSubUserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  List list = ['View Only', 'Edit Only', 'Administrator'];
  String userId = "";
  bool userFound = false;

  Future<void> findUser(String phNo) async {
    await FirebaseFirestore.instance.collection('users').get().then((docs) {
      for (var doc in docs.docs) {
        print(doc.data()['phone']);
        if (doc.data()['phone'].toString() == phNo) {
          setState(() {
            userId = doc.id;
            userFound = true;
          });
        }
      }
    });
  }

  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = "View Only";
    });
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    addVerticalSpace(20),
                    Text(
                      "Add Sub User",
                      style: bodyText22w600(color: black),
                    ),
                    addVerticalSpace(40),
                    Image.asset("assets/images/adduser.png"),
                    addVerticalSpace(20),
                    CustomTextField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                    CustomTextField(
                        hintText: "Search by Mobile Number",
                        controller: phoneController),
                    // CustomDropdown(list: list, height: 58, hint: "View only")
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
                                        selectedValue.isNotEmpty
                                            ? selectedValue
                                            : "View Only",
                                        style:
                                            bodyText16normal(color: darkGray),
                                      ),
                                      style: bodyText15normal(color: black),
                                      dropdownColor: white,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      items: list.map((e) {
                                        return DropdownMenuItem(
                                            value: e.toString(),
                                            child: Text(e.toString()));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                        print(selectedValue);

                                        // print(widget.value);
                                        // print(widget.value);
                                      }),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ]),
                ),
              ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: CustomButton(
                    text: "Add",
                    onClick: () async {
                      await findUser(phoneController.text.toString());
                      if (userFound) {
                        if (userId == widget.owner) {
                          Fluttertoast.showToast(
                              msg: "Cannot add self as sub-user!");
                        } else {
                          await FirebaseFirestore.instance
                              .collection('batches')
                              .doc(batchDocIds[widget.index])
                              .update({
                            'userIDs': FieldValue.arrayUnion([
                              {
                                "name": nameController.text.toString(),
                                "id": userId,
                                "type": selectedValue,
                              },
                            ]),
                          });
                          Fluttertoast.showToast(
                              msg: "User successfully added to batch!");

                          Navigator.pop(context, true);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "No User found with the specified data!");
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
