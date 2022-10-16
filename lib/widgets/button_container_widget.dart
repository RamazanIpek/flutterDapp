import 'package:flutter/material.dart';

class CustomContainerButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final int? value;
  const CustomContainerButtonWidget(
      {super.key,
      required this.title,
      required this.color,
      required this.onTap,
      this.value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
