import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import '../../widgets/generalappbar.dart';

var user = FirebaseAuth.instance.currentUser?.uid;

class AddNotesPage extends StatefulWidget {
  String batchId;
  String owner;
  bool? isEdit;
  String? title;
  int? batchIndex;
  String? date;
  String? description;
  List? upto;
  List? after;
  AddNotesPage({
    super.key,
    required this.batchId,
    required this.owner,
    this.isEdit,
    this.title,
    this.description,
    this.batchIndex,
    this.date,
    this.upto,
    this.after,
  });
  @override
  AddNotesState createState() => AddNotesState();
}

class AddNotesState extends State<AddNotesPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      titleController.text = widget.title!;
      descriptionController.text = widget.description!;
    }
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Add Notes",
                  style: bodyText22w600(color: black),
                ),
              ),
              addVerticalSpace(15),
              CustomTextField(
                hintText: 'Title',
                controller: titleController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: descriptionController,
                  cursorColor: black,
                  maxLines: 10,
                  style: bodyText15normal(color: black),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(232, 236, 244, 1),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: normalGray),
                          borderRadius: BorderRadius.circular(8.5)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: normalGray),
                          borderRadius: BorderRadius.circular(8.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: red),
                          borderRadius: BorderRadius.circular(8.5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: normalGray),
                          borderRadius: BorderRadius.circular(8.5)),
                      hintText: 'Description',
                      hintStyle: bodyText16normal(color: darkGray)),
                ),
              ),
              const Spacer(),
              CustomButton(
                  text: 'Add',
                  onClick: () async {
                    if (widget.isEdit == true) {
                      Map current = {};

                      current.addAll({
                        "date": widget.date,
                        "Title": titleController.text.toString(),
                        "Description": descriptionController.text.toString(),
                      });

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.owner)
                          .collection('Batches')
                          .doc(widget.batchId)
                          .collection('BatchData')
                          .doc('Notes')
                          .set({
                        "notes": widget.upto! + [current] + widget.after!,
                      });

                      Fluttertoast.showToast(msg: "Data updated successfully!");
                    } else {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.owner)
                          .collection('Batches')
                          .doc(widget.batchId)
                          .collection('BatchData')
                          .doc('Notes')
                          .set({
                        "notes": FieldValue.arrayUnion([
                          {
                            "date":
                                DateFormat("dd/MM/yyyy").format(DateTime.now()),
                            'Title': titleController.text.toString(),
                            'Description':
                                descriptionController.text.toString(),
                          }
                        ]),
                      }, SetOptions(merge: true));
                    }
                    Navigator.pop(context, true);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
