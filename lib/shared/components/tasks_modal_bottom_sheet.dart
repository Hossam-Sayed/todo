import 'package:flutter/material.dart';
import 'package:home/shared/components/components.dart';
import 'package:home/shared/components/constants.dart';
import 'package:home/shared/components/default_text_form_field.dart';
import 'package:home/shared/components/priority_chip.dart';
import 'package:home/shared/components/sizedboxes.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:intl/intl.dart';

class TasksModalBottomSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController dateController;
  final int? id;

  const TasksModalBottomSheet({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.timeController,
    required this.dateController,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextFormField(
                    controller: titleController,
                    type: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Title must not be empty';
                      }
                      return null;
                    },
                    label: 'Task Title',
                    prefixIcon: Icons.title,
                  ),
                  defaultVerticalSizedBox,
                  DefaultTextFormField(
                    controller: dateController,
                    readOnlyField: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2030-01-01'),
                        builder: (context, child) =>
                            applyDatePickerTheme(context, child),
                      ).then((value) {
                        if (value != null) {
                          dateController.text =
                              DateFormat.yMMMd().format(value);
                        }
                      });
                    },
                    type: TextInputType.datetime,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Date must not be empty';
                      }
                      return null;
                    },
                    label: 'Task Date',
                    prefixIcon: Icons.date_range,
                  ),
                  defaultVerticalSizedBox,
                  DefaultTextFormField(
                    controller: timeController,
                    readOnlyField: true,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          timeController.text =
                              value.format(context).toString();
                        }
                      });
                    },
                    type: TextInputType.datetime,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Time must not be empty';
                      }
                      return null;
                    },
                    label: 'Task Time',
                    prefixIcon: Icons.watch_later_outlined,
                  ),
                  defaultVerticalSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PriorityChip(
                        label: Priority.critical.label,
                        color: Priority.critical.color,
                        chipIndex: 0,
                      ),
                      PriorityChip(
                        label: Priority.high.label,
                        color: Priority.high.color,
                        chipIndex: 1,
                      ),
                      PriorityChip(
                        label: Priority.normal.label,
                        color: Priority.normal.color,
                        chipIndex: 2,
                      ),
                      PriorityChip(
                        label: Priority.low.label,
                        color: Priority.low.color,
                        chipIndex: 3,
                      ),
                    ],
                  ),
                  defaultVerticalSizedBox,
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (id == null) {
                          cubit.insertToDB(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                            priority: cubit.choiceIndex,
                          );
                        } else {
                          cubit.updateTaskDB(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              priority: cubit.choiceIndex,
                              id: id);
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: const WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                      minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 60.0),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(id == null ? Icons.add : Icons.save_rounded),
                        defaultHorizontalSizedBox,
                        Text(
                          id == null ? 'Add Task' : 'Save Task',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
