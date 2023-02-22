import 'package:flutter/material.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';

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

Widget taskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      background: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              alignment: AlignmentDirectional.centerStart,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    10.0,
                  ),
                  bottomLeft: Radius.circular(
                    10.0,
                  ),
                ),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              alignment: AlignmentDirectional.centerEnd,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    10.0,
                  ),
                  bottomRight: Radius.circular(
                    10.0,
                  ),
                ),
              ),
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
        margin: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          // right: 20.0,
          // left: 20.0,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Colors.transparent],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model['date']} ・ ${model['time']}',
                    style: const TextStyle(
                      color: Color(0x66FFFFFF),
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
      icon: doneIcon(),
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
      icon: archiveIcon(),
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
          icon: doneIcon(),
          tooltip: 'Mark as done',
        ),
        IconButton(
          onPressed: () {
            AppCubit.get(context).updateDB(
              status: 'archive',
              id: model['id'],
            );
          },
          icon: archiveIcon(),
          tooltip: 'Archive task',
        ),
      ],
    );
  }
}

Icon doneIcon() => const Icon(
      Icons.check_circle,
      color: Color(0xFF0078eb),
    );

Icon archiveIcon() => const Icon(
      Icons.archive,
      color: Color(0xFF0078eb),
    );

Widget tasksBuilder({
  required List<Map> tasks,
  required AppStates state,
}) =>
    tasks.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(
              right: 10.0,
              left: 10.0,
            ),
            color: Colors.transparent,
            child: ListView.builder(
              itemBuilder: (context, index) => taskItem(tasks[index], context),
              itemCount: tasks.length,
              physics: const BouncingScrollPhysics(),
            ),
          )
        : (state is AppGetDatabaseState ||
                state is AppChangeBottomNavBarState ||
                state is AppChangeBottomSheetState ||
                state is AppChangeAppMode)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.task,
                      size: 100.0,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Tasks',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0078eb),
                ),
              );
