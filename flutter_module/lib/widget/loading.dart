import 'package:flutter/material.dart';

class LoadingAnimationLinear extends StatefulWidget {
  @override
  _LoadingAnimationLinearState createState() => _LoadingAnimationLinearState();
}

class _LoadingAnimationLinearState extends State<LoadingAnimationLinear> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(
              value: null,
            )));
  }
}

class LoadingAnimationCircular extends StatefulWidget {
  @override
  _LoadingAnimationCircularState createState() =>
      _LoadingAnimationCircularState();
}

class _LoadingAnimationCircularState extends State<LoadingAnimationCircular> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: null,
            )));
  }
}
