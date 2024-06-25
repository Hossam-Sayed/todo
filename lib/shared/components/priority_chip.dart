import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

class PriorityChip extends StatelessWidget {
  final String label;
  final int chipIndex;
  final Color color;

  const PriorityChip({
    super.key,
    required this.label,
    required this.color,
    required this.chipIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ChoiceChip(
          avatar: const CircleAvatar(
            backgroundColor: Colors.white30,
            child: Icon(
              Icons.priority_high_rounded,
              color: Colors.white,
              size: 16.0,
            ),
          ),
          label: Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectedColor: color,
          selected: cubit.choiceIndex == chipIndex,
          onSelected: (bool selected) {
            if (selected) {
              cubit.changeChoiceIndex(chipIndex);
            }
          },
        );
      },
    );
  }
}
