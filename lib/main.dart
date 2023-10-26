import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/core/theme/theme.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/di.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/splash/splash_screen.dart';

import 'core/navigation/router.dart';
import 'feature/main_tables/main_table_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// tasks
///
/// 1 - Sync tabBar to GridView
/// 2 - Dark Light Theme
/// 3 - number picker state problem
///

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("MyApp.build()");
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
