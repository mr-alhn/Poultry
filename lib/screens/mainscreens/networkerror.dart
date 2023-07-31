import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/screenloading.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class NetworkErrorPage extends StatefulWidget {
  const NetworkErrorPage({super.key});

  @override
  State<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends State<NetworkErrorPage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 2), () => NextScreen(context, const ScreenLoadingPage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/error.png",
            ),
            addVerticalSpace(25),
            Text(
              "Page Not Found",
              style: bodyText18w500(color: black),
            ),
            addVerticalSpace(20),
            Text(
              "Try and check your internet connection",
              style: bodyText14normal(color: black),
            ),
          ],
        ),
      ),
    );
  }
}
