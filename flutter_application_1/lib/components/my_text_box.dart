import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final Function()? onpressed;

  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //sectionName
              Text(sectionName, style: const TextStyle(color: Colors.teal)),
              //edit button
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.grey),
                onPressed: onpressed,
              ),
            ],
          )
        ],
      ),
    );
  }
}