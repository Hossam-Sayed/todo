import 'package:flutter/material.dart';
import 'package:home/shared/components/constants.dart';

class PriorityBadge extends StatelessWidget {
  final int priority;
  const PriorityBadge({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Priority.fromInt(priority).color,
      ),
      alignment: AlignmentDirectional.center,
      child: Text(
        Priority.fromInt(priority).label.toUpperCase(),
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
