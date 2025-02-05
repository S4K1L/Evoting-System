import 'package:flutter/material.dart';

Widget buildText(String text, bool checked) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          checked
              ? const Icon(Icons.check, color: Colors.green, size: 24)
              : const Icon(Icons.close, color: Colors.red, size: 24),
          const SizedBox(width: 3),
          Text(text,
              style: TextStyle(
                  fontSize: 15, color: Colors.black.withOpacity(0.6))),
        ],
      ),
    );
