import 'package:flutter/material.dart';

Future showCustomModalBottomSheet(BuildContext context, Widget child) async {
  return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (_) => child,
  );
}

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;

  CustomBottomSheet({@required this.children});

  @override
  Widget build(BuildContext context) {
    children.insert(0, SizedBox(height: 10));
    children.add(SizedBox(height: 10));

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
