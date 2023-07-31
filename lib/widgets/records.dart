import 'package:flutter/material.dart';

import 'package:poultry_app/utils/constants.dart';

class RecordsWidget extends StatelessWidget {
  final List<dynamic> record;
  const RecordsWidget({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
        itemCount: record.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => record[index]['screen']))
                  .then((value) {});
            },
            leading: Image.asset(
              record[index]['lead'],
              color: black,
              height: 22,
            ),
            title: Text(
              record[index]['text'],
              style: bodyText16w500(color: const Color(0xFF242736)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: black,
              size: 18,
            ),
          );
        });
  }
}
