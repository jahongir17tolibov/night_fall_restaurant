import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/feature/change_tables/main_table_screen.dart';
import 'package:night_fall_restaurant/feature/home/home_screen.dart';
import 'package:night_fall_restaurant/feature/orders/orders_screen.dart';
import 'package:night_fall_restaurant/feature/splash/splash_screen.dart';

class RouterNavigation {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashScreen.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case MainTableScreen.ROUTE_NAME:
        return MaterialPageRoute(builder: (_) => const MainTableScreen());
      case HomeScreen.ROUTE_NAME:
        {
          // final String tableNumberArgument = routeSettings.arguments as String;
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }

      case OrdersScreen.ROUTE_NAME:
        return CupertinoPageRoute(builder: (_) => const OrdersScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
