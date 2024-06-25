import 'package:flutter/material.dart';
import 'package:home/modules/trash/trash_screen.dart';
import 'package:home/shared/components/sizedboxes.dart';

class EmptyTasks extends StatelessWidget {
  final TaskType type;
  const EmptyTasks({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (type == TaskType.active)
          const Positioned(
            right: 48.0,
            bottom: 0.0,
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/arrow.png"),
                  width: 150.0,
                ),
              ],
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/images/no_tasks.png"),
                width: 150.0,
              ),
              defaultVerticalSizedBox,
              const Text(
                'No Tasks',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4.0),
                color: Theme.of(context).colorScheme.surface,
                child: type == TaskType.active
                    ? const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Tap the ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.add_task,
                                size: 20.0,
                              ),
                              Text(
                                ' button below to add',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'the thing you need to do!',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        textAlign: TextAlign.center,
                        type == TaskType.done
                            ? 'Time to get some tasks done!'
                            : 'Temporarily deleted tasks\nwill appear here!',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
