import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  const MyPixel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.grey[900],
        ),
      ),
    );
  }
}
