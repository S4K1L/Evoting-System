import 'package:evote/utils/constant/colors.dart';
import 'package:flutter/material.dart';

class RectangleCustomButton extends StatelessWidget {
  const RectangleCustomButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kPrimaryColor),
      child: TextButton(
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(color: kWhiteColor, fontSize: 18),
        ),
      ),
    );
  }
}