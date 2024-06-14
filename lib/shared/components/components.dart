import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/layout/home_layout.dart';
import 'package:home/modules/task_details/task_details_screen.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class DefaultTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String? Function(String?) validator;
  final String label;
  final IconData prefixIcon;
  final bool readOnlyField;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? initialValue;
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.type,
    required this.validator,
    required this.label,
    required this.prefixIcon,
    this.readOnlyField = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnlyField,
      showCursor: true,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
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
  }
}

Widget tasksBuilder({
  required List<Map> tasks,
  required AppStates state,
  required ScrollController controller,
  required bool isActive,
  required AppCubit cubit,
  bool isDone = true,
}) =>
    tasks.isNotEmpty
        ? ListView.separated(
            controller: controller,
            itemBuilder: (context, index) => buildTaskItem(
              tasks[index],
              context,
              Theme.of(context).colorScheme.secondary,
            ),
            separatorBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              height: 1.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            itemCount: tasks.length,
            physics: const BouncingScrollPhysics(),
          )
        : (state is AppGetDatabaseLoadingState)
            ? const Center(
                child: CircularProgressIndicator(
                    // color: Theme.of(context).colorScheme.secondary,
                    ),
              )
            : Center(
                child: isActive
                    ? buildNoTasksActive(cubit)
                    : buildNoTasksDone(isDone),
              );

Widget buildTaskItem(Map task, context, Color color) => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(task),
          ),
        );
      },
      child: Dismissible(
        key: Key(task['id'].toString()),
        background: Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          alignment: AlignmentDirectional.centerStart,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                (task['status'] == 'active')
                    ? Icons.task_alt
                    : Icons.unpublished,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                (task['status'] == 'active')
                    ? 'Mark as done'
                    : 'Mark as active',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                (task['status'] == 'delete') ? 'Delete' : 'Move to trash',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
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
                      '${task['title']}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 15.0,
                          color: Color(0x998D8D8D),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${task['date']} ・ ',
                          style: const TextStyle(
                            color: Color(0x998D8D8D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.access_time_filled,
                          size: 15.0,
                          color: Color(0x998D8D8D),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${task['time']}',
                          style: const TextStyle(
                            color: Color(0x998D8D8D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              PriorityBadge(priority: task['priority']),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
        ),
        onDismissed: (direction) {},
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            return showDialog(
              context: context,
              builder: (newContext) {
                return showAlert(context, task);
              },
            );
          } else if (task['status'] == 'done' || task['status'] == 'delete') {
            AppCubit.get(context).updateStatusDB(
              status: 'active',
              id: task['id'],
            );
          } else {
            AppCubit.get(context).updateStatusDB(
              status: 'done',
              id: task['id'],
            );
          }
          return Future.value(true);
        },
      ),
    );

Widget buildNoTasksActive(AppCubit cubit) => const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150.0,
        ),
        Image(
          image: AssetImage(
            "assets/images/no_tasks.png",
          ),
          width: 150.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'No Tasks',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          'Tap the + button below to add\nthe thing you need to do!',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160.0,
            ),
            Image(
              image: AssetImage(
                "assets/images/arrow.png",
              ),
              width: 150.0,
            ),
          ],
        ),
      ],
    );

Widget buildNoTasksDone(bool isDone) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage(
            "assets/images/no_tasks.png",
          ),
          width: 150.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        const Text(
          'No Tasks',
          style: TextStyle(
            fontSize: 20.0,
            // color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          isDone
              ? 'Time to get some tasks done!'
              : 'Temporarily deleted tasks\nwill appear here!',
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
      ],
    );

class PriorityBadge extends StatelessWidget {
  final int priority;
  const PriorityBadge({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    print('############### Priority: $priority');
    return Container(
      height: 25.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: prioritiesColors[priority],
      ),
      alignment: AlignmentDirectional.center,
      child: Text(
        prioritiesLabels[priority].toUpperCase(),
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

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

Widget buildChip({
  required String label,
  required Color color,
  required int chipIndex,
}) =>
    BlocBuilder<AppCubit, AppStates>(
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
              context.read<AppCubit>().changeChoiceIndex(chipIndex);
              // cubit.changeChoiceIndex(chipIndex);
            }
          },
        );
      },
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

// Theme applyTimePickerTheme(context, child) => (cubit.isLight)
//     ? Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: Theme.of(context).colorScheme.secondary,
//             onPrimary: Theme.of(context).colorScheme.primary,
//             onSurface: Theme.of(context).colorScheme.secondary,
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               foregroundColor: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ),
//         child: child!,
//       )
//     : Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: ColorScheme.dark(
//             primary: Theme.of(context).colorScheme.secondary,
//             onPrimary: Theme.of(context).colorScheme.primary,
//             onSurface: Theme.of(context).colorScheme.secondary,
//             surface: Theme.of(context).colorScheme.primary,
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               foregroundColor: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ),
//         child: child!,
//       );
// Scrollable.of(context).position.pixels

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
  required GlobalKey<ScaffoldState> scaffoldKey,
  required TextEditingController titleController,
  required TextEditingController timeController,
  required TextEditingController dateController,
  required BuildContext context,
  bool isInsert = true,
  int? id,
}) {
  showModalBottomSheet(
    isDismissible: true,
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 5.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            const SizedBox(height: 10.0),
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
                  const SizedBox(height: 15.0),
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
                  const SizedBox(
                    height: 15.0,
                  ),
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
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildChip(
                        label: prioritiesLabels[0],
                        color: prioritiesColors[0],
                        chipIndex: 0,
                      ),
                      buildChip(
                        label: prioritiesLabels[1],
                        color: prioritiesColors[1],
                        chipIndex: 1,
                      ),
                      buildChip(
                        label: prioritiesLabels[2],
                        color: prioritiesColors[2],
                        chipIndex: 2,
                      ),
                      buildChip(
                        label: prioritiesLabels[3],
                        color: prioritiesColors[3],
                        chipIndex: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isInsert) {
                          AppCubit.get(context).insertToDB(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                            priority: HomeLayout.choiceIndex,
                          );
                        } else {
                          AppCubit.get(context).updateTaskDB(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              priority: HomeLayout.choiceIndex,
                              id: id);
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: const MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(double.infinity, 60.0),
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isInsert ? Icons.add : Icons.save_rounded),
                        const SizedBox(width: 8.0),
                        Text(
                          isInsert ? 'Add Task' : 'Save Task',
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
  );
  // .closed.then((value) {
  //   cubit.changeBottomSheetState(
  //     isShown: false,
  //     icon: isInsert ? Icons.add_task : Icons.edit,
  //     isMainFab: isInsert,
  //   );
  //   HomeLayout.choiceIndex = 2;
  //   titleController.clear();
  //   timeController.clear();
  //   dateController.clear();
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.immersiveSticky,
  //   );
  // });
  // cubit.changeBottomSheetState(
  //   isShown: true,
  //   icon: isInsert ? Icons.add : Icons.save,
  //   isMainFab: isInsert,
  // );
}
