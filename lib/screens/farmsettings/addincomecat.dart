import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

import '../batches/addeggs.dart';

class AddIncomeCategory extends StatelessWidget {
  AddIncomeCategory({super.key});
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final fireStore = FirebaseFirestore.instance.collection('users').doc(user).collection("settings").doc(user).collection("Income Category");
  final incomeCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Add Income Category",
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) * 0.88,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CustomTextField(hintText: "Category",
                  controller: incomeCategoryController,),
                ),
                const Spacer(),
                CustomButton(text: "Add", onClick: () async{

                  ({
                    fireStore.doc().set({

                      'IncomeCategory':incomeCategoryController.text.toString(),

                    }),});

                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
