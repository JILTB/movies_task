import 'package:flutter/material.dart';

class SquareIconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color buttonColor;

  const SquareIconTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 50,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
