import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/myads.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';

class ShowDialogBox extends StatelessWidget {
  final String? message;
  final String? subMessage;
  final bool? isShowAds;
  const ShowDialogBox(
      {super.key, this.message, this.subMessage, this.isShowAds});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addVerticalSpace(10),
            Image.asset(
              "assets/images/verify.png",
              height: 109,
              width: 109,
              fit: BoxFit.fill,
            ),
            addVerticalSpace(40),
            Text(
              message ?? "",
              style: bodyText28Bold(color: black),
            ),
            subMessage != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 35),
                    child: Text(
                      textAlign: TextAlign.center,
                      subMessage ?? "",
                      style: bodyText16normal(color: darkGray, height: 1.5),
                    ),
                  )
                : addVerticalSpace(0),
            subMessage != null
                ? addVerticalSpace(0)
                : isShowAds == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomButton(
                          text: "View Ad",
                          onClick: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => const MyAds()));
                          },
                          width: 200,
                          height: 40,
                          textStyle: bodyText16Bold(color: white),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
