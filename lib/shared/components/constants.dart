import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/cubit.dart';

late AppCubit mainCubit;
const brightColor = Colors.white;
const Color darkColor = Color(0xFF171a1c);
const List<String> prioritiesLabels = ['Critical', 'High', 'Normal', 'Low'];
const List<ColorSwatch> prioritiesColors = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.deepPurpleAccent
];
List<dynamic> prioritiesLightColors = [
  Colors.red[50],
  Colors.orange[50],
  Colors.green[50],
  Colors.deepPurple[50]
];

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
