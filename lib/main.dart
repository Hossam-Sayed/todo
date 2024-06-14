import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/shared/components/constants.dart';
import 'package:home/shared/cubit/cubit.dart';
import 'package:home/shared/cubit/states.dart';
import 'package:home/shared/network/local/cache_helper.dart';
import 'layout/home_layout.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
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
    return BlocProvider(
      create: (context) => AppCubit()
        ..createDB()
        ..toggleMode(modeBool: isLight),
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomeLayout(),
            themeMode: cubit.isLight ? ThemeMode.light : ThemeMode.dark,
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: brightColor,
                background: brightColor,
                secondary: darkColor,
                error: Colors.red,
              ),
              iconTheme: const IconThemeData(color: darkColor),
              appBarTheme: const AppBarTheme(backgroundColor: brightColor),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                foregroundColor: brightColor,
                backgroundColor: darkColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(color: darkColor),
                unselectedItemColor: Color(0xFF696c73),
                backgroundColor: brightColor,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                elevation: 5.0,
                selectedItemColor: darkColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              chipTheme: const ChipThemeData(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                showCheckmark: false,
                labelPadding: EdgeInsets.all(2.0),
                pressElevation: 0.0,
                backgroundColor: Color(0x33000000),
              ),
              fontFamily: 'Nunito',
              datePickerTheme: const DatePickerThemeData(
                todayForegroundColor: MaterialStatePropertyAll(darkColor),
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
                  overlayColor: MaterialStatePropertyAll(Color(0x11ff0000)),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(darkColor),
                  overlayColor: MaterialStatePropertyAll(Color(0x11000000)),
                ),
              ),
              timePickerTheme: const TimePickerThemeData(
                dayPeriodColor: Colors.grey,
                dialHandColor: darkColor,
                hourMinuteTextColor: darkColor,
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
                  overlayColor: MaterialStatePropertyAll(Color(0x11ff0000)),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(darkColor),
                  overlayColor: MaterialStatePropertyAll(Color(0x11000000)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: darkColor,
                background: darkColor,
                secondary: brightColor,
                // secondary: Color(0x33FFFFFF),
                // secondary: Color(0xff1f1d2b),
                error: Colors.red,
              ),
              iconTheme: const IconThemeData(color: brightColor),
              appBarTheme: const AppBarTheme(backgroundColor: darkColor),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                foregroundColor: darkColor,
                backgroundColor: brightColor,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(color: brightColor),
                unselectedItemColor: Color(0xFF696c73),
                // backgroundColor: darkColor,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                elevation: 5.0,
                selectedItemColor: brightColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              chipTheme: const ChipThemeData(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                showCheckmark: false,
                labelPadding: EdgeInsets.all(2.0),
                pressElevation: 0.0,
                backgroundColor: Color(0x33FFFFFF),
                padding: EdgeInsets.all(8.0),
              ),
              fontFamily: 'Nunito',
              datePickerTheme: const DatePickerThemeData(
                todayForegroundColor: MaterialStatePropertyAll(brightColor),
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
                  overlayColor: MaterialStatePropertyAll(Color(0x11ff0000)),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(brightColor),
                  overlayColor: MaterialStatePropertyAll(Color(0x11FFFFFF)),
                ),
              ),
              timePickerTheme: const TimePickerThemeData(
                dayPeriodColor: Colors.grey,
                dialHandColor: brightColor,
                hourMinuteTextColor: brightColor,
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.red),
                  overlayColor: MaterialStatePropertyAll(Color(0x11ff0000)),
                ),
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(brightColor),
                  overlayColor: MaterialStatePropertyAll(Color(0x11000000)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
