import 'package:flutter/material.dart';

class CreationAwareItem extends StatefulWidget {
  final void Function() onCreation;
  final Widget child;

  const CreationAwareItem({Key key, this.onCreation, this.child})
      : super(key: key);

  @override
  _CreationAwareItemState createState() => _CreationAwareItemState();
}

class _CreationAwareItemState extends State<CreationAwareItem> {
  @override
  void initState() {
    super.initState();
    widget.onCreation();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
