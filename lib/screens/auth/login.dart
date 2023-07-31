import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:poultry_app/screens/auth/otpverification.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/appbar.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/socialauthbutton.dart';

final _auth = FirebaseAuth.instance;

class LogIn extends StatefulWidget {
  const LogIn({
    super.key,
  });

  static String verify = "";

  @override
  State<LogIn> createState() => _LogInState();
}

var phone = TextEditingController();

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Validation() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height(context) - 92,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    addVerticalSpace(height(context) * .035),
                    Text(
                      "Welcome back! Glad\nto see you, Again!",
                      style: bodyText30Bold(color: black),
                    ),
                    addVerticalSpace(height(context) * .05),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: formkey,
                      child: TextFormField(
                        maxLength: 10,
                        controller: phone,
                        keyboardType: TextInputType.number,
                        validator: MinLengthValidator(10,
                            errorText: "Enter a valid number"),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
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
                            hintText: "Phone Number",
                            hintStyle: bodyText16normal(color: darkGray)),
                      ),
                    ),
                    CustomButton(
                      height: 55,
                      width: width(context),
                      onClick: () async {
                        await _auth.verifyPhoneNumber(
                          phoneNumber: "+91${phone.text}",
                          verificationCompleted:
                              (PhoneAuthCredential credential) {
                            print('Auth verified!');
                            // NextScreen(context, Register());
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            print('wrong otp');
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            LogIn.verify = verificationId;
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                        // Validation();
                        if (Validation()) {
                          NextScreen(context, const OTPVerification());
                        }
                      },
                      text: "Send OTP",
                    ),
                    addVerticalSpace(height(context) * .1),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or Login with",
                            style: bodyText14w600(color: darkGray),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    addVerticalSpace(15),
                    const SocialAuthButton(),
                  ],
                ),
                // IfNotButton(
                //     onClick: () => NextScreen(context, Register()),
                //     message: "Don't have an account?",
                //     action: "Register Now")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
