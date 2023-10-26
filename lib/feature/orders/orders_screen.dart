import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/utils/constants.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

import '../../utils/ui_components/on_back_navigate.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextView(
          text: 'My orders',
          textColor: Theme.of(context).colorScheme.onSurface,
        ),
        leading: onBackNavigate(context, homeRoute),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextView(
            text: 'Orders screen',
            textColor: Theme.of(context).colorScheme.onBackground,
          )
        ],
      ),
    );
  }
}
