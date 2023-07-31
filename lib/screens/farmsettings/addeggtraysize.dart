import 'package:flutter/material.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class AddTraysSize extends StatelessWidget {
  const AddTraysSize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Egg Tray Size",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child:
                  CustomTextField(hintText: "Standard Egg Tray Size: 30 Eggs"),
            ),
            CustomButton(text: "Add", onClick: () {})
          ],
        ),
      ),
    );
  }
}
