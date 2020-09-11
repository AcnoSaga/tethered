import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tethered/utils/enums/tab_item.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<TabItem>(context, listen: false).toString()),
      ),
      body: Center(
          child: FlatButton(
        child: Text(Provider.of<TabItem>(context, listen: false).toString()),
        onPressed: () {
          Get.toNamed(
              Provider.of<TabItem>(context, listen: false) == TabItem.search
                  ? '/details'
                  : '/detail',
              id: tabItemsToIndex[
                  Provider.of<TabItem>(context, listen: false)]);
        },
      )),
    );
  }
}