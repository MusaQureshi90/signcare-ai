import 'package:flutter/material.dart';

/// 0 se 10 tak rangeen gol buttons (hamesha left-to-right)
class ScaleRow extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;
  const ScaleRow({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (int i = 0; i <= 10; i++) _dot(i),
        ],
      ),
    );
  }

  Widget _dot(int i) {
    final color = Color.lerp(Colors.green, Colors.red, i / 10)!;
    final selected = value == i;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => onChanged(i),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: Text(
          '$i',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}