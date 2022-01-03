import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;
  final Color color;
  const CustomButton(
      {Key key, @required this.name, this.color, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(name),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: color,
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),

      /// Deprecated
      // child: RaisedButton(
      //   child: Text(
      //     name,
      //     style: const TextStyle(fontSize: 18, color: Colors.white),
      //   ),
      //   color: color,
      //   onPressed: onPressed,
      // ),
    );
  }
}
