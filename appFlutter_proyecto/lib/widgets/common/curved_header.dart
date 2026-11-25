import 'package:flutter/material.dart';

class CurvedHeader extends StatelessWidget {
  final double height;
  final Widget child;

  const CurvedHeader({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFF1C3A70),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: child,
    );
  }
}