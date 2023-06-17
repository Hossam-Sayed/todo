import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/cubit.dart';

late AppCubit cubit;
const brightColor = Colors.white;
const Color darkColor = Color(0xFF171a1c);
const List<String> prioritiesLabels = ['Critical', 'High', 'Normal', 'Low'];
const List<ColorSwatch> prioritiesColors = [
  Colors.red,
  Colors.orange,
  Colors.green,
  Colors.deepPurpleAccent
];

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
