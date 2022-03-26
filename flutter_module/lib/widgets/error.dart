import 'package:flutter/material.dart';

class ErrorAnimation extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
        height: (MediaQuery.of(context).size.height),
        child: Text('Another unexpected situation.'));
  }
}
