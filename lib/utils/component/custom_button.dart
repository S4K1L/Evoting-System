import 'package:evote/utils/constant/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key, required this.title, required this.onPress,
  });
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/16,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor
      ),
      child: TextButton(
        onPressed: onPress,
        child: Text(title,style: const TextStyle(fontSize: 18,color: kWhiteColor),),
      ),
    );
  }
}