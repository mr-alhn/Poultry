import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:poultry_app/screens/bottomnav.dart';
import 'package:poultry_app/screens/profile/createprofile.dart';

import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/navigation.dart';

class SocialAuthButton extends StatefulWidget {
  const SocialAuthButton({super.key});
  @override
  MySocialAuthButtonState createState() => MySocialAuthButtonState();
}

class MySocialAuthButtonState extends State<SocialAuthButton> {
  bool isExisting = false;

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      Fluttertoast.showToast(msg: "Sign in Successful!");
      print(value);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((docs) {
        if (docs.exists) {
          setState(() {
            isExisting = true;
          });
        } else {
          setState(() {
            isExisting = false;
          });
        }
      });
      showDialog(
          context: context,
          builder: (context) => ShowDialogBox(
              message: isExisting ? "Welcome back!" : "Registered!",
              subMessage: isExisting
                  ? "You Logged in successfully."
                  : "You Registered successfully!"));
      Timer(
          const Duration(seconds: 5),
          () => NextScreen(
              context,
              isExisting
                  ? const BottomNavigation()
                  : CreateProfilePage(
                      usingPhoneNumber: false,
                      name: value.user!.displayName,
                      email: value.user!.email,
                    )));
    });
  }

  Future<void> signInWithFacebook() async {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Container(
            width: width(context) / 3.55,
            height: 60,
            decoration: shadowDecoration(8.5, 1, white),
            child: Image.asset(
              "assets/images/f.png",
            ),
          ),
          onTap: () {
            Fluttertoast.showToast(msg: "Coming soon!");
          },
        ),
        GestureDetector(
          onTap: () {
            signInWithGoogle();
          },
          child: Container(
            width: width(context) / 3.55,
            height: 60,
            decoration: shadowDecoration(8.5, 1, white),
            child: Image.asset("assets/images/g.png"),
          ),
        ),
        GestureDetector(
          onTap: () {
            Fluttertoast.showToast(msg: "Coming soon!");
          },
          child: Container(
            width: width(context) / 3.55,
            height: 60,
            decoration: shadowDecoration(8.5, 1, white),
            child: Image.asset("assets/images/a.png"),
          ),
        ),
      ],
    );
  }
}
