import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:poultry_app/screens/auth/login.dart';
import 'package:poultry_app/screens/bottomnav.dart';
import 'package:poultry_app/screens/profile/createprofile.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/appbar.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/dialogbox.dart';
import 'package:poultry_app/widgets/ifnotbutton.dart';
import 'package:poultry_app/widgets/navigation.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

bool isExisting = false;

class _OTPVerificationState extends State<OTPVerification> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _pinPutController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  var code;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width(context) * .2,
      height: width(context) * .185,
      textStyle: bodyText24w600(color: black),
      decoration: BoxDecoration(
        border: Border.all(color: yellow),
        borderRadius: BorderRadius.circular(8.5),
      ),
    );
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: SizedBox(
        height: height(context) - 92,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(height(context) * .035),
                    Text(
                      "OTP Verification",
                      style: bodyText30Bold(color: black),
                    ),
                    addVerticalSpace(height(context) * .03),
                    Text(
                      "Enter the verification code we just sent on your email address.",
                      style: bodyText16normal(color: darkGray),
                    ),
                    addVerticalSpace(height(context) * 0.06),
                    Form(
                      child: Pinput(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        key: key,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        controller: _pinPutController,
                        pinAnimationType: PinAnimationType.fade,
                        onChanged: (value) {
                          setState(() {
                            code = value;
                          });
                        },
                      ),
                    ),
                    addVerticalSpace(height(context) * 0.03),
                    CustomButton(
                        height: 55,
                        width: width(context),
                        text: "Verify",
                        onClick: () async {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: LogIn.verify,
                                    smsCode: code);
                            await auth.signInWithCredential(credential);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get()
                                .then((docs) {
                              if (docs.exists) {
                                setState(() {
                                  isExisting = true;
                                });
                                Fluttertoast.showToast(msg: "Existing User!");
                              } else {
                                setState(() {
                                  isExisting = false;
                                });
                                Fluttertoast.showToast(msg: "New User!");
                              }
                            });
                          } catch (e) {
                            print("Wrong OTP");
                          }
                          showDialog(
                              context: context,
                              builder: (context) => ShowDialogBox(
                                  message: isExisting
                                      ? "Welcome back!"
                                      : "Registered!",
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
                                          usingPhoneNumber: true,
                                        )));
                        })
                  ],
                ),
              ),
              IfNotButton(
                  onClick: () {},
                  message: "Didn't received code?",
                  action: "Resend")
            ]),
      ),
    );
  }
}
