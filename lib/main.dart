import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/core/theme/theme.dart';
import 'package:night_fall_restaurant/core/theme/theme_bloc/theme_bloc.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/di.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/main_table_screen.dart';
import 'package:night_fall_restaurant/feature/splash/SplashScreen.dart';
import 'package:night_fall_restaurant/utils/custom_tab_bar_indicator.dart';
import 'firebase_options.dart';
import 'core/navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
        BlocProvider<TablesBloc>(create: (context) => getIt<TablesBloc>()),
      ],
      child: MaterialApp(
        onGenerateRoute: RouterNavigation.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
