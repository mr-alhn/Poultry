import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

import '../../utils/constants.dart';
import '../../widgets/customdropdown.dart';
import '../../widgets/customtextfield.dart';
import '../../widgets/navigation.dart';
import '../batches/addeggs.dart';
import '../profile/editprofile.dart';

List list = ["Broiler", "Deshi", "Layer", "Breeder Farm"];
String name = " ";
String email = " ";
String farmName = " ";
String country = " ";
String state = " ";
String city = " ";
String Village = " ";
String farmCapacity = " ";
String farmType = "";
bool isLoading = true;

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});
  @override
  UserInformationPageState createState() => UserInformationPageState();
}

class UserInformationPageState extends State<UserInformationPage> {
  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user).get().then((value) {
      setState(() {
        name = value["name"].toString();
        email = value["email"].toString();
        farmName = value["FarmName"].toString();
        country = value["Country"].toString();
        state = value["State"].toString();
        city = value["City"].toString();
        farmCapacity = value["Farm Capacity"].toString();
        farmType = value["Type"].toString();
        isLoading = false;
      });
    });

    print(name);
    print(
        farmType); // List<QueryDocumentSnapshot> docs = querySnapshot.('BVd0YvbKBfacEmMJIzrD');

    //print("int "+querySnapshot.get("date").toString());
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(name);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: true,
          bottom: true,
          title: "User Information",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
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
                        CustomTextField(
                          hintText: name,
                          enabled: false,
                        ),
                        CustomTextField(hintText: email),
                        CustomTextField(hintText: farmName),
                        Row(
                          children: [
                            Expanded(child: CustomTextField(hintText: country)),
                            addHorizontalySpace(20),
                            Expanded(child: CustomTextField(hintText: state)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: CustomTextField(
                              hintText: city,
                            )),
                            // addHorizontalySpace(20),
                            // Expanded(
                            //   child: CustomTextField(
                            //     hintText: "Village",
                            //   ),
                            // ),
                          ],
                        ),
                        CustomTextField(hintText: farmCapacity),
                        CustomDropdown(
                          list: list,
                          height: 58,
                          hint: farmType.isNotEmpty ? farmType : "Farm",
                          value: farmType,
                        ),
                      ],
                    ),
                    CustomButton(text: "Save", onClick: () {})
                  ],
                ),
        ),
      ),
    );
  }
}
