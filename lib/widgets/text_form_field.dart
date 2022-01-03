import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String name;

  const MyTextFormField({
    Key key,
    @required this.controller,
    @required this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: name,
      ),
    );
  }
}
