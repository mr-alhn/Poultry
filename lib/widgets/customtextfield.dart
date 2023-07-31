import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/tablecal.dart';

class CustomTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final String hintText;
  final bool? suffix;
  final TextInputType? textType;
  final bool? autoValidate;
  final bool? enabled;
  final int? maxLength;
  final bool? editable;
  bool canSelectBefore = false;
  DateTime? cannotSelectBefore; 

  // final double? height;
  final TextEditingController? controller;

  var onchanged;

  CustomTextField({
    super.key,
    required this.hintText,
    this.onchanged,
    this.suffix,
    this.validator,
    this.editable = true,
    // this.height,
    this.maxLength,
    this.textType,
    this.autoValidate,
    this.controller,
    this.cannotSelectBefore,
    this.canSelectBefore = false,
    this.enabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String currentDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          enabled: widget.enabled,
          onChanged: widget.onchanged,
          controller: widget.controller,
          keyboardType: widget.textType ?? TextInputType.text,
          validator: widget.validator,
          cursorColor: black,
          style: bodyText15normal(color: black),
          maxLength: widget.maxLength,
          readOnly: widget.suffix ?? false,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              filled: true,
              fillColor: const Color.fromRGBO(232, 236, 244, 1),
              suffixIcon: widget.suffix == true
                  ? IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowCalendar(
                              controller: widget.controller!,
                              canSelectBefore: widget.canSelectBefore,
                              cannotSelectBefore: widget.cannotSelectBefore,
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: gray,
                      ))
                  : null,
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
              hintText: widget.hintText,
              hintStyle: bodyText16normal(color: darkGray)),
        ),
      ),
    );
  }
}
