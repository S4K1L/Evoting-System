import 'package:evote/utils/constant/colors.dart';
import 'package:flutter/material.dart';

class CustomTiles extends StatelessWidget {
  const CustomTiles(
      {super.key,
        required this.title,
        required this.onTap, required this.icon});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 50,
            )
          ],
          color: Colors.blue,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon,color: kWhiteColor,size: 32,),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22, color: kWhiteColor, letterSpacing: 2.5,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}