import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';

class FloatedButton extends StatelessWidget {
  final VoidCallback onTap;
  const FloatedButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: FloatingActionButton(
        backgroundColor: yellow,
        onPressed: onTap,
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}
