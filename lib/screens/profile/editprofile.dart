import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customtextfield.dart';
import 'package:poultry_app/widgets/dialogbox.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        foregroundColor: black,
        title: Text(
          "Edit Profile",
          style: bodyText18w600(color: black),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Column(
                children: [
                  addVerticalSpace(20),
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
                              child: CircleAvatar(
                                  backgroundColor: yellow,
                                  radius: 14,
                                  child: Icon(
                                    Icons.edit,
                                    size: 17,
                                    color: white,
                                  )),
                            ))
                      ],
                    ),
                  ),
                  addVerticalSpace(20),
                  CustomTextField(hintText: "Name"),
                  CustomTextField(hintText: "Email"),
                  CustomTextField(hintText: "Farm Name"),
                  Row(
                    children: [
                      Expanded(child: CustomTextField(hintText: "Country")),
                      addHorizontalySpace(20),
                      Expanded(child: CustomTextField(hintText: "State")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        hintText: "City",
                      )),
                      addHorizontalySpace(20),
                      Expanded(
                          child: CustomTextField(
                        hintText: "Village",
                      )),
                    ],
                  ),
                  CustomTextField(hintText: "Farm Capacity"),
                  CustomTextField(hintText: "Farm"),
                ],
              ),
              addVerticalSpace(15),
              CustomButton(
                  height: 55,
                  width: width(context),
                  text: "Edit",
                  onClick: () {
                    showDialog(
                        context: context,
                        builder: (context) => const ShowDialogBox(
                            message: "Profile Edit!",
                            subMessage:
                                "Your profile has been edited\nsuccessfully."));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
