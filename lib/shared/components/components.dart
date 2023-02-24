import 'package:flutter/material.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

import 'constants.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validator,
  required String label,
  required IconData prefixIcon,
  bool readOnlyField = false,
  VoidCallback? onTap,
  Function(String)? onFieldSubmitted,
  Function(String)? onChanged,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnlyField,
      showCursor: true,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
      ),
    );

Widget taskItem(Map model, context, Color color) => Dismissible(
      key: Key(model['id'].toString()),
      background: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              alignment: AlignmentDirectional.centerStart,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']} ・ ${model['time']}',
                    style: const TextStyle(
                      color: Color(0x998D8D8D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            addTaskControls(model, context),
          ],
        ),
      ),
      onDismissed: (direction) {},
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (newContext) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              title: const Text('Delete Task?'),
              content: const Text('Task will be deleted permanently'),
              actions: [
                TextButton(
                  onPressed: () {
                    AppCubit.get(context).deleteDB(
                      id: model['id'],
                    );
                    return Navigator.pop(context);
                  },
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
              ],
            );
          },
        );
      },
    );

Widget addTaskControls(Map model, context) {
  if (model['status'] == 'archive') {
    return IconButton(
      onPressed: () {
        AppCubit.get(context).updateDB(
          status: 'done',
          id: model['id'],
        );
      },
      icon: doneIcon(cubit.secondaryColor),
      tooltip: 'Mark as done',
    );
  } else if (model['status'] == 'done') {
    return IconButton(
      onPressed: () {
        AppCubit.get(context).updateDB(
          status: 'archive',
          id: model['id'],
        );
      },
      icon: archiveIcon(cubit.secondaryColor),
      tooltip: 'Archive task',
    );
  } else {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateDB(
              status: 'done',
              id: model['id'],
            );
          },
          icon: doneIcon(cubit.secondaryColor),
          tooltip: 'Mark as done',
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateDB(
              status: 'archive',
              id: model['id'],
            );
          },
          icon: archiveIcon(cubit.secondaryColor),
          tooltip: 'Archive task',
        ),
      ],
    );
  }
}

Icon doneIcon(Color color) => Icon(
      Icons.check_circle,
      color: color,
    );

Icon archiveIcon(Color color) => Icon(
      Icons.archive,
      color: color,
    );

Widget tasksBuilder({
  required List<Map> tasks,
  required AppStates state,
}) =>
    tasks.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) => taskItem(
              tasks[index],
              context,
              cubit.secondaryColor,
            ),
            separatorBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              height: 1.0,
              color: cubit.secondaryColor,
            ),
            itemCount: tasks.length,
            physics: const BouncingScrollPhysics(),
          )
        : (state is AppGetDatabaseState ||
                state is AppChangeBottomNavBarState ||
                state is AppChangeBottomSheetState ||
                state is AppChangeAppMode)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task,
                      size: 100.0,
                      color: cubit.secondaryColor,
                    ),
                    Text(
                      'No Tasks',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: cubit.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: cubit.secondaryColor,
                ),
              );
