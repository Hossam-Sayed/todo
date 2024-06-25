import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

const brightColor = Colors.white;
// const Color darkColor = Color(0xFF171a1c);
const Color darkColor = Colors.black;

enum Priority {
  critical(
    label: 'Critical',
    color: Colors.red,
  ),
  high(
    label: 'High',
    color: Colors.orange,
  ),
  normal(
    label: 'Normal',
    color: Colors.green,
  ),
  low(
    label: 'Low',
    color: Colors.deepPurpleAccent,
  );

  final String label;
  final Color color;

  const Priority({
    required this.label,
    required this.color,
  });

  static Priority fromInt(int typeAsInt) {
    switch (typeAsInt) {
      case 0:
        return Priority.critical;
      case 1:
        return Priority.high;
      case 2:
        return Priority.normal;
      default:
        return Priority.low;
    }
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }
}
