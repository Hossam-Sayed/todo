import 'package:flutter/material.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'tasks_modal_bottom_sheet.dart';

Widget showAlert(context, task) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      title: (task['status'] == 'delete')
          ? const Text(
              'Delete Task?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          : const Text(
              'Move to Trash?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
      content: (task['status'] == 'delete')
          ? const Text(
              'Task will be deleted permanently',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          : const Text(
              'Task will be moved to trash',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            (task['status'] == 'delete')
                ? AppCubit.get(context).deleteDB(
                    id: task['id'],
                  )
                : AppCubit.get(context).updateStatusDB(
                    status: 'delete',
                    id: task['id'],
                  );
            return Navigator.pop(context);
          },
          child: Text(
            (task['status'] == 'delete') ? 'DELETE' : 'MOVE TO TRASH',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

Theme applyDatePickerTheme(context, child) => AppCubit.get(context).isLight
    ? Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.grey),
        ),
        child: child!,
      )
    : Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: Colors.grey),
        ),
        child: child!,
      );

Widget buildCustomContainer(String name) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0x668D8D8D),
      ),
      alignment: AlignmentDirectional.centerStart,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            // color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );

void onFabPress({
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController timeController,
  required TextEditingController dateController,
  required BuildContext context,
  int? id,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (context) => TasksModalBottomSheet(
      formKey: formKey,
      titleController: titleController,
      dateController: dateController,
      timeController: timeController,
      id: id,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    elevation: 15.0,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        strokeAlign: 1.0,
        color: Theme.of(context).colorScheme.secondary,
      ),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(
          25.0,
        ),
      ),
    ),
  ).then((value) => AppCubit.get(context).changeChoiceIndex(2));
}
