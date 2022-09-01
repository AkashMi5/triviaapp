import 'package:flutter/material.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key key, @required this.onButtonPress})
      : super(key: key);

  final VoidCallback onButtonPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onButtonPress();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(8)),
      child: Text(
        'Try Again',
        style: TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }
}
