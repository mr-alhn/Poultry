import 'package:flutter/material.dart';

NextScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

goBack(BuildContext context) {
  Navigator.pop(context);
}
