import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/constants.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/network/local/cache_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'layout/home_layout.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  databaseFactory = databaseFactoryFfi;
  await CacheHelper.init();
  bool? isLight = CacheHelper.getModeData(key: 'isLight');
  runApp(MyApp(isLight));
}

class MyApp extends StatelessWidget {
  final bool? isLight;

  const MyApp(this.isLight, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AppCubit()
        ..createDB()
        ..toggleMode(modeBool: isLight),
        child: HomeLayout(isLight),
      ),
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
    );
  }
}
