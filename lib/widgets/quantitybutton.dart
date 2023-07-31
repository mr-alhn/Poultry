import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';

class QuantityButton extends StatefulWidget {
  bool canIncrease;
  int totalQuantity;
  int current;
  QuantityButton(
      {super.key,
      this.canIncrease = true,
      required this.totalQuantity,
      required this.current});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Bags Quantity",
              style: bodyText15w500(color: darkGray),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.current > 0) {
                    setState(() {
                      widget.current--;
                      print(widget.current);
                    });
                  }
                },
                child: Container(
                  width: 42,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: tfColor,
                      border: Border.all(color: yellow)),
                  child: Icon(
                    Icons.remove,
                    size: 25,
                    color: yellow,
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 51,
                decoration: BoxDecoration(
                    color: tfColor,
                    border: Border(
                      bottom: BorderSide(color: normalGray),
                      top: BorderSide(color: normalGray),
                    )),
                child: Center(
                  child: Text(
                    widget.current.toString(),
                    style: bodyText15w500(color: darkGray),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.current < widget.totalQuantity
                      ? setState(() {
                          widget.current++;
                        })
                      : Fluttertoast.showToast(msg: "Stock not available!");
                },
                child: Container(
                  height: 60,
                  width: 42,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: tfColor,
                      border: Border.all(color: yellow)),
                  child: Icon(
                    Icons.add,
                    size: 25,
                    color: yellow,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
