import 'package:flutter/material.dart';
import 'package:home/layout/home_layout.dart';
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
      style: TextStyle(
        color: cubit.secondaryColor,
      ),
      cursorColor: cubit.secondaryColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: cubit.secondaryColor,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: cubit.secondaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: cubit.secondaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: cubit.secondaryColor,
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

Widget tasksBuilder({
  required List<Map> tasks,
  required AppStates state,
  required ScrollController controller,
  required bool isActive,
}) =>
    tasks.isNotEmpty
        ? NotificationListener(
            onNotification: (notification) {
              if (controller.position.pixels <= 100 && !cubit.isFabVisible) {
                cubit.setFabEnable(true);
              } else if (controller.position.pixels > 100 &&
                  cubit.isFabEnabled) {
                cubit.setFabVisibility(false);
              }
              // print(controller.position.pixels);
              return true;
            },
            child: ListView.separated(
              controller: controller,
              itemBuilder: (context, index) => buildTaskItem(
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
            ),
          )
        : (state is AppGetDatabaseLoadingState)
            ? Center(
                child: CircularProgressIndicator(
                  color: cubit.secondaryColor,
                ),
              )
            : Center(
                child: isActive ? buildNoTasksActive() : buildNoTasksDone(),
              );

Widget buildTaskItem(Map task, context, Color color) => Dismissible(
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
              (task['status'] == 'active') ? Icons.task_alt : Icons.unpublished,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              (task['status'] == 'active') ? 'Mark as done' : 'Mark as undone',
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
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${task['date']} ・ ${task['time']}',
                    style: const TextStyle(
                        color: Color(0x998D8D8D),
                        fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            buildPriorityBadge(task['priority']),
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
          AppCubit.get(context).updateDB(
            status: 'active',
            id: task['id'],
          );
        } else {
          AppCubit.get(context).updateDB(
            status: 'done',
            id: task['id'],
          );
        }
        return Future.value(true);
      },
    );

Widget buildNoTasksDone() => Column(
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
        Text(
          'No Tasks',
          style: TextStyle(
            fontSize: 25.0,
            color: cubit.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          textAlign: TextAlign.center,
          'Time to get some tasks done!',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
          ),
        ),
      ],
    );

Widget buildNoTasksActive() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150.0,
        ),
        const Image(
          image: AssetImage(
            "assets/images/no_tasks.png",
          ),
          width: 150.0,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'No Tasks',
          style: TextStyle(
            fontSize: 25.0,
            color: cubit.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          textAlign: TextAlign.center,
          'Tap the + button below to add\nthe thing you need to do!',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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

Widget buildPriorityBadge(int priority) => Container(
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
          color: cubit.primaryColor,
        ),
      ),
    );

Widget showAlert(context, task) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.0,
          ),
        ),
      ),
      title: (task['status'] == 'delete')
          ? const Text('Delete Task?')
          : const Text('Move to Trash?'),
      content: (task['status'] == 'delete')
          ? const Text('Task will be deleted permanently')
          : const Text('Task will be moved to trash'),
      actions: [
        TextButton(
          onPressed: () {
            (task['status'] == 'delete')
                ? AppCubit.get(context).deleteDB(
                    id: task['id'],
                  )
                : AppCubit.get(context).updateDB(
                    status: 'delete',
                    id: task['id'],
                  );
            return Navigator.pop(context);
          },
          child: Text(
            (task['status'] == 'delete') ? 'DELETE' : 'MOVE TO TRASH',
            style: const TextStyle(
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

Widget buildChip({
  required String label,
  required Color color,
  required int chipIndex,
  required setState,
}) =>
    ChoiceChip(
      labelPadding: const EdgeInsets.all(2.0),
      avatar: const CircleAvatar(
        backgroundColor: Colors.white30,
        child: Icon(
          Icons.priority_high_rounded,
          color: Colors.white,
          size: 15.0,
        ),
      ),
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      pressElevation: 0.0,
      backgroundColor: Colors.grey[400],
      selectedColor: color,
      padding: const EdgeInsets.all(8.0),
      selected: HomeLayout.choiceIndex == chipIndex,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            HomeLayout.choiceIndex = chipIndex;
          });
        }
      },
    );

Theme applyDatePickerTheme(context, child) => (cubit.isLight)
    ? Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: cubit.secondaryColor,
            onPrimary: cubit.primaryColor,
            onSurface: cubit.secondaryColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: cubit.secondaryColor,
            ),
          ),
        ),
        child: child!,
      )
    : Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: cubit.primaryColor,
            onPrimary: cubit.secondaryColor,
            brightness: Brightness.light,
            onSurface: cubit.primaryColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: cubit.primaryColor,
            ),
          ),
        ),
        child: child!,
      );

Theme applyTimePickerTheme(context, child) => (cubit.isLight)
    ? Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: cubit.secondaryColor,
            onPrimary: cubit.primaryColor,
            onSurface: cubit.secondaryColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: cubit.secondaryColor,
            ),
          ),
        ),
        child: child!,
      )
    : Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
              primary: cubit.secondaryColor,
              onPrimary: cubit.primaryColor,
              onSurface: cubit.secondaryColor,
              surface: cubit.primaryColor),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: cubit.secondaryColor,
            ),
          ),
        ),
        child: child!,
      );
// Scrollable.of(context).position.pixels
