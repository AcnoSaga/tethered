import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/utils/enums/tab_item.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: TextButton(
          child: Text('Back'),
          onPressed: () {
            Get.toNamed(
              '/detail',
              id: tabItemsToIndex[Provider.of<TabItem>(context, listen: false)],
            );
          },
        ),
      )),
    );
  }
}
