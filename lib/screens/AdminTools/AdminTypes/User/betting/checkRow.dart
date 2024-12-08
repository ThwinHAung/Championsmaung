import 'package:flutter/material.dart';

class CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8, // Adjust the checkbox size
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8.0), // Space between checkbox and text
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14.0), // Adjust the text size
          ),
        ),
      ],
    );
  }
}
