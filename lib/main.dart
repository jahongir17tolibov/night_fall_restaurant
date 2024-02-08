import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/core/theme/cubit/theme_cubit.dart';
import 'package:night_fall_restaurant/core/theme/theme.dart';
import 'package:night_fall_restaurant/di.dart';
import 'package:night_fall_restaurant/feature/change_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/home/bloc/home_bloc.dart';
import 'package:night_fall_restaurant/feature/splash/splash_screen.dart';

import 'core/navigation/router.dart';
import 'feature/orders/bloc/orders_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeCubit>()..initializeAppTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(create: (context) => getIt<HomeBloc>()),
            BlocProvider<OrdersBloc>(create: (context) => getIt<OrdersBloc>()),
          ],
          child: MaterialApp(
            onGenerateRoute: RouterNavigation.generateRoute,
            debugShowCheckedModeBanner: false,
            themeMode: state.appThemeMode == AppThemeMode.light
                ? ThemeMode.light
                : ThemeMode.dark,
            theme: appLightTheme,
            darkTheme: appDarkTheme,
            home: Builder(
              builder: (context) => const SplashScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
