import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home/layout/home_layout.dart';
import 'package:home/modules/task_details/task_details_screen.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validator,
  required String label,
  required IconData prefixIcon,
  required AppCubit cubit,
  bool readOnlyField = false,
  VoidCallback? onTap,
  Function(String)? onFieldSubmitted,
  Function(String)? onChanged,
  String? initialValue,
}) =>
    TextFormField(
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
  required AppCubit cubit,
  bool isDone = true,
}) =>
    tasks.isNotEmpty
        ? ListView.separated(
            controller: controller,
            itemBuilder: (context, index) => buildTaskItem(
              tasks[index],
              context,
              cubit.secondaryColor,
              cubit,
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
        : (state is AppGetDatabaseLoadingState)
            ? Center(
                child: CircularProgressIndicator(
                  color: cubit.secondaryColor,
                ),
              )
            : Center(
                child: isActive
                    ? buildNoTasksActive(cubit)
                    : buildNoTasksDone(isDone, cubit),
              );

Widget buildTaskItem(Map task, context, Color color, AppCubit cubit) => InkWell(
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
              buildPriorityBadge(task['priority'], cubit),
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

Widget buildNoTasksActive(AppCubit cubit) => Column(
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
            fontSize: 20.0,
            color: cubit.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          textAlign: TextAlign.center,
          'Tap the + button below to add\nthe thing you need to do!',
          style: TextStyle(
            fontSize: 18.0,
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

Widget buildNoTasksDone(bool isDone, AppCubit cubit) => Column(
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
            fontSize: 20.0,
            color: cubit.secondaryColor,
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

Widget buildPriorityBadge(int priority, AppCubit cubit) => Container(
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
                : AppCubit.get(context).updateStatusDB(
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

Theme applyDatePickerTheme(context, child, AppCubit cubit) => (cubit.isLight)
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

Theme applyTimePickerTheme(context, child, AppCubit cubit) => (cubit.isLight)
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

Widget buildCustomContainer(String name, AppCubit cubit) => Container(
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
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: cubit.secondaryColor,
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
  required AppCubit cubit,
  bool isInsert = true,
  int? id,
}) {
  if (cubit.isBottomSheetShown) {
    if (formKey.currentState!.validate()) {
      if (isInsert) {
        cubit.insertToDB(
          title: titleController.text,
          time: timeController.text,
          date: dateController.text,
          priority: HomeLayout.choiceIndex,
        );
      } else {
        cubit.updateTaskDB(
            title: titleController.text,
            date: dateController.text,
            time: timeController.text,
            priority: HomeLayout.choiceIndex,
            id: id);
      }
    }
  } else {
    scaffoldKey.currentState
        ?.showBottomSheet(
          (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    height: 5.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: cubit.secondaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTextFormField(
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
                          cubit: cubit,
                        ),
                        const SizedBox(height: 15.0),
                        defaultTextFormField(
                          controller: dateController,
                          readOnlyField: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2030-01-01'),
                              builder: (context, child) =>
                                  applyDatePickerTheme(context, child, cubit),
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
                          cubit: cubit,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          controller: timeController,
                          readOnlyField: true,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) =>
                                  applyTimePickerTheme(context, child, cubit),
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
                          cubit: cubit,
                        ),
                        const SizedBox(height: 15.0),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter changeState) =>
                                  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildChip(
                                label: prioritiesLabels[0],
                                color: prioritiesColors[0],
                                chipIndex: 0,
                                setState: changeState,
                              ),
                              buildChip(
                                label: prioritiesLabels[1],
                                color: prioritiesColors[1],
                                chipIndex: 1,
                                setState: changeState,
                              ),
                              buildChip(
                                label: prioritiesLabels[2],
                                color: prioritiesColors[2],
                                chipIndex: 2,
                                setState: changeState,
                              ),
                              buildChip(
                                label: prioritiesLabels[3],
                                color: prioritiesColors[3],
                                chipIndex: 3,
                                setState: changeState,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          backgroundColor: cubit.primaryColor,
          elevation: 15.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              strokeAlign: 1.0,
              color: cubit.secondaryColor,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(
                25.0,
              ),
            ),
          ),
        )
        .closed
        .then((value) {
      cubit.changeBottomSheetState(
        isShown: false,
        icon: isInsert ? Icons.add_task : Icons.edit,
        isMainFab: isInsert,
      );
      HomeLayout.choiceIndex = 2;
      titleController.clear();
      timeController.clear();
      dateController.clear();
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    });
    cubit.changeBottomSheetState(
      isShown: true,
      icon: isInsert ? Icons.add : Icons.save,
      isMainFab: isInsert,
    );
  }
}
