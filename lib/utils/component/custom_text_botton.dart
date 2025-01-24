import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key, required this.firstText, required this.secondText, required this.onPress,
  });
  final String firstText;
  final String secondText;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(firstText,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          Text(
            secondText,
            style: const TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
        ],
      ),
    );
  }
}