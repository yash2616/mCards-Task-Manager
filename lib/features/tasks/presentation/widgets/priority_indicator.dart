import 'package:flutter/material.dart';

import '../../domain/enums/priority_level.dart';

class PriorityIndicator extends StatelessWidget {
  final PriorityLevel level;
  const PriorityIndicator({super.key, required this.level});

  Color get _color {
    switch (level) {
      case PriorityLevel.critical:
        return Colors.redAccent;
      case PriorityLevel.high:
        return Colors.orange;
      case PriorityLevel.medium:
        return Colors.amber;
      case PriorityLevel.low:
      return Colors.green;
    }
  }

  String get _label {
    switch (level) {
      case PriorityLevel.critical:
        return 'Critical';
      case PriorityLevel.high:
        return 'High';
      case PriorityLevel.medium:
        return 'Med';
      case PriorityLevel.low:
      return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label,
        textAlign: TextAlign.center,
        style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
