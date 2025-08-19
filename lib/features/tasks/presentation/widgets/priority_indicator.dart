import 'package:flutter/material.dart';

import '../../domain/entities/priority_level.dart';

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
      default:
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
      default:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: TextStyle(color: _color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
