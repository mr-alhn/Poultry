import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class EditMyAds extends StatefulWidget {
  final String? title;
  int index;
  EditMyAds({super.key, this.title, required this.index});

  @override
  State<EditMyAds> createState() => _EditMyAdsState();
}

class _EditMyAdsState extends State<EditMyAds> {
  List upto = [];
  List after = [];
  Map current = {};
  TextEditingController quantityController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> getDetails(int index) async {
    await FirebaseFirestore.instance
        .collection("ads")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["advertisementDetails"].length; i++) {
          if (i == index) {
            setState(() {
              cityController.text =
                  value.data()!["advertisementDetails"][i]["city"];
              descriptionController.text =
                  value.data()!["advertisementDetails"][i]["description"];
              contactController.text =
                  value.data()!["advertisementDetails"][i]["contact"];
              villageController.text =
                  value.data()!["advertisementDetails"][i]["village"];
              stateController.text =
                  value.data()!["advertisementDetails"][i]["state"];
              quantityController.text = value
                  .data()!["advertisementDetails"][i]["quantity"]
                  .toString();

              current["date"] =
                  value.data()!["advertisementDetails"][i]["date"];
              current["imageUrl"] =
                  value.data()!["advertisementDetails"][i]["imageUrl"];
              current["type"] =
                  value.data()!["advertisementDetails"][i]["type"];
              current["sold"] =
                  value.data()!["advertisementDetails"][i]["sold"];
            });
          } else {
            if (i < index) {
              setState(() {
                upto.add({
                  "city": value.data()!["advertisementDetails"][i]["city"],
                  "description": value.data()!["advertisementDetails"][i]
                      ["description"],
                  "contact": value.data()!["advertisementDetails"][i]
                      ["contact"],
                  "village": value.data()!["advertisementDetails"][i]
                      ["village"],
                  "state": value.data()!["advertisementDetails"][i]["state"],
                  "quantity": int.parse(value
                      .data()!["advertisementDetails"][i]["quantity"]
                      .toString()),
                  "date": value.data()!["advertisementDetails"][i]["date"],
                  "sold": value.data()!["advertisementDetails"][i]["sold"],
                  "imageUrl": value.data()!["advertisementDetails"][i]
                          ["imageUrl"] ??
                      "",
                  "type": value.data()!["advertisementDetails"][i]["type"],
                });
              });
            } else {
              setState(() {
                after.add({
                  "city": value.data()!["advertisementDetails"][i]["city"],
                  "description": value.data()!["advertisementDetails"][i]
                      ["description"],
                  "contact": value.data()!["advertisementDetails"][i]
                      ["contact"],
                  "village": value.data()!["advertisementDetails"][i]
                      ["village"],
                  "state": value.data()!["advertisementDetails"][i]["state"],
                  "quantity": int.parse(value
                      .data()!["advertisementDetails"][i]["quantity"]
                      .toString()),
                  "date": value.data()!["advertisementDetails"][i]["date"],
                  "sold": value.data()!["advertisementDetails"][i]["sold"],
                  "imageUrl": value.data()!["advertisementDetails"][i]
                          ["imageUrl"] ??
                      "",
                  "type": value.data()!["advertisementDetails"][i]["type"],
                });
              });
            }
          }
        }
      }
    });
    print("Before: $upto");
    print("current: $current");
    print("later $after");
  }

  @override
  void initState() {
    super.initState();
    getDetails(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "Edit Your Ad",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.title ?? "",
                  style: bodyText18w600(color: black),
                ),
              ),
              SizedBox(
                width: width(context),
                height: width(context) * .35,
                child: current["imageUrl"] == "" || current["imageUrl"] == null
                    ? Center(
                        child: Text("No Image",
                            style: bodyText14w500(color: black)))
                    : Image.network(
                        current["imageUrl"],
                        fit: BoxFit.cover,
                      ),
              ),
              addVerticalSpace(20),
              CustomTextField(
                hintText: "Quantity",
                controller: quantityController,
              ),
              CustomTextField(
                hintText: "Contact Number",
                controller: contactController,
              ),
              CustomTextField(
                hintText: "State",
                controller: stateController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "City",
                      controller: cityController,
                    ),
                  ),
                  addHorizontalySpace(20),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Village",
                      controller: villageController,
                    ),
                  )
                ],
              ),
              CustomTextField(
                hintText: "Description",
                controller: descriptionController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ',
                    style: bodyText15normal(color: black.withOpacity(0.6)),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        current["sold"] = true;
                      });

                      print(current);

                      // Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 40,
                      width: width(context) * 0.3,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(40, 180, 70, 0.35),
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          'Sold',
                          style: bodyText14Bold(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      height: 40,
                      width: width(context) * 0.3,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 67, 54, 0.35),
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: bodyText14Bold(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (contactController.text.toString().trim().length != 10) {
                      Fluttertoast.showToast(
                          msg: "Enter a valid Contact number!");
                    } else {
                      current["city"] = cityController.text.toString();
                      current["quantity"] = quantityController.text.toString();
                      current["contact"] = contactController.text.toString();
                      current["state"] = stateController.text.toString();
                      current["village"] = villageController.text.toString();
                      current["description"] =
                          descriptionController.text.toString();

                      List updatedArray = upto + [current] + after;

                      await FirebaseFirestore.instance
                          .collection("ads")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        "advertisementDetails": updatedArray,
                      });

                      Navigator.pop(context, true);
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(180, 40),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(yellow),
                  ),
                  child: Text(
                    "Edit",
                    style: bodyText14w500(color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
