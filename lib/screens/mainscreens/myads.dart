import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAdsPage extends StatefulWidget {
  String type,
      description,
      contact,
      state,
      city,
      village,
      datePosted,
      quantity,
      imageUrl;

  MyAdsPage({
    super.key,
    required this.type,
    required this.imageUrl,
    required this.description,
    required this.quantity,
    required this.contact,
    required this.state,
    required this.city,
    required this.village,
    required this.datePosted,
  });

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "Advertisement",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(10),
              Center(
                child: Text(
                  widget.type,
                  style: bodyText20w600(color: black),
                ),
              ),
              addVerticalSpace(25),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.imageUrl == ""
                    ? SizedBox(
                        height: 127,
                        width: width(context),
                        child: Center(
                          child: Text(
                            "No Image",
                            style: bodyText14w500(color: black),
                          ),
                        ),
                      )
                    : Image.network(
                        widget.imageUrl,
                        height: 127,
                        width: width(context),
                        fit: BoxFit.fill,
                      ),
              ),
              addVerticalSpace(30),
              Text(
                "Description:",
                style: bodyText15w500(color: black),
              ),
              Text(
                widget.description,
                style: bodyText13normal(color: black),
              ),
              addVerticalSpace(25),
              Text(
                "Quantity: ${widget.quantity}",
                style: bodyText15w500(color: black),
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "Contact Number: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    "+91-${widget.contact}",
                    style: bodyText15normal(color: black),
                  ),
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "State: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    widget.state,
                    style: bodyText15normal(color: black),
                  )
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  SizedBox(
                    width: width(context) * .45,
                    child: Row(
                      children: [
                        Text(
                          "City: ",
                          style: bodyText15w500(color: black),
                        ),
                        Text(
                          widget.city,
                          style: bodyText15normal(color: black),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Village: ",
                        style: bodyText15w500(color: black),
                      ),
                      Text(
                        widget.village,
                        style: bodyText15normal(color: black),
                      )
                    ],
                  ),
                ],
              ),
              addVerticalSpace(25),
              Row(
                children: [
                  Text(
                    "Ad Posted On: ",
                    style: bodyText15w500(color: black),
                  ),
                  Text(
                    widget.datePosted,
                    style: bodyText15normal(color: black),
                  )
                ],
              ),
              addVerticalSpace(60),
              CustomButton(
                  text: "Call Seller",
                  onClick: () async {
                    Uri phoneNo = Uri.parse('tel:+91${widget.contact}');
                    if (await launchUrl(phoneNo)) {
                    } else {
                      Fluttertoast.showToast(msg: "Dialer error!");
                    }
                  },
                  width: width(context),
                  height: 58)
            ],
          ),
        ),
      ),
    );
  }
}
