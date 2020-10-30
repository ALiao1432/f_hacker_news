import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:f_hacker_news/cubit/cubit_observer.dart';
import 'package:f_hacker_news/cubit/home/home_cubit.dart';
import 'package:f_hacker_news/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'router/router.gr.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  configureInjection(Env.release);
  Bloc.observer = StateObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getThemeData(),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(),
          ),
        ],
        child: ExtendedNavigator<router.Router>(
          router: router.Router(),
        ),
      ),
      onGenerateRoute: router.Router(),
    );
  }

  ThemeData getThemeData() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xfff4f4eb),
        primaryColor: const Color(0xfff4f4eb),
        dividerTheme: DividerThemeData(
          indent: 3,
          endIndent: 3,
          color: Colors.black.withOpacity(.5),
        ),
      );
}
