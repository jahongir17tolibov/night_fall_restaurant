import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/feature/orders/bloc/orders_bloc.dart';
import 'package:night_fall_restaurant/utils/constants.dart';
import 'package:night_fall_restaurant/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

import '../../data/local/entities/orders_entity.dart';
import '../../utils/helpers.dart';
import '../../utils/ui_components/on_back_navigate.dart';
import '../../utils/ui_components/shimmer_gradient.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  static const String lottieFilePath = 'assets/anim/cart_is_empty_lottie.json';

  late int _pricesCount;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    context.read<OrdersBloc>().add(OrdersOnGetProductsEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pricesCount = context.watch<OrdersBloc>().pricesCount;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<OrdersBloc>().add(OrdersOnClearProductsEvent());
            },
            icon: Icon(
              Icons.clear_all_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextView(
          text: 'My orders',
          textColor: Theme.of(context).colorScheme.onSurface,
        ),
        leading: IconButton(
          onPressed: () {
            context.read<OrdersBloc>().add(OrdersOnNavigateBackEvent());
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocConsumer<OrdersBloc, OrdersState>(
        buildWhen: (previous, current) => current is! OrdersActionState,
        listenWhen: (previous, current) => current is OrdersActionState,
        builder: (context, state) {
          switch (state) {
            case OrdersLoadingState():
              return Center(
                child: CupertinoActivityIndicator(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  radius: 36.0,
                ),
              );
            case OrdersSuccessState():
              {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 6.0,
                            ),
                            scrollDirection: Axis.vertical,
                            physics: Platform.isIOS
                                ? const BouncingScrollPhysics()
                                : const BouncingScrollPhysics(),
                            itemCount: state.ordersList.length,
                            itemBuilder: (context, index) {
                              final item = state.ordersList[index];
                              return _ordersItem(
                                title: item.name,
                                image: item.image,
                                price: item.price,
                              );
                            }),
                      ),
                      _ordersListCard(list: state.ordersList),
                    ],
                  ),
                );
              }
            case OrdersIsEmptyState():
              return _cartIsEmptyAnim();
            case OrdersErrorState():
              return errorWidget(state.error, context);
            default:
              return Container();
          }
        },
        listener: (BuildContext context, OrdersState state) {
          if (state is OrdersListenOnBackNavigateState) {
            Navigator.of(context).pop();
          }
          if (state is OrdersShowSnackBarOnSendOrdersState) {
            showSnackBar(state.message, context);
          }
        },
      ),
    );
  }

  Widget _ordersItem({
    required String title,
    required String image,
    required String price,
  }) {
    /// imageView
    Widget productsImage = ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: CachedNetworkImage(
        imageUrl: image,
        width: 70.0,
        height: 90.0,
        fit: BoxFit.fill,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          decoration: BoxDecoration(
            gradient: shimmerEffect(
              context,
              AnimationController(
                vsync: this,
                duration: const Duration(seconds: 1),
              )..repeat(reverse: true),
            ),
          ),
        ),
      ),
    );

    /// list tile
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      splashColor: Theme.of(context).colorScheme.secondaryContainer,
      leading: productsImage,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: TextView(
        text: title,
        textColor: Theme.of(context).colorScheme.onSurface,
        textSize: 22.0,
        maxLines: 1,
        weight: FontWeight.w500,
      ),
      subtitle: TextView(
        text: price,
        textColor: Theme.of(context).colorScheme.onSurface,
        textSize: 12.5,
        maxLines: 1,
      ),
    );
  }

  Widget _ordersListCard({required List<OrdersEntity> list}) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.all(12.0),
      elevation: 6.0,
      child: Container(
        width: fillMaxWidth(context),
        height: 220.0,
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _ordersRowCardItem(
                      name: item.name,
                      count: item.quantity.toString(),
                      price: item.price,
                    );
                  }),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextView(
                  text: 'Umumiy:  ',
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  textSize: 20.0,
                  maxLines: 1,
                ),
                TextView(
                  text:
                      "${NumberFormat.decimalPatternDigits().format(_pricesCount)} so'm",
                  textColor: Theme.of(context).colorScheme.onSecondary,
                  textSize: 20.0,
                  weight: FontWeight.w700,
                  maxLines: 1,
                )
              ],
            ),
            const SizedBox(height: 8.0),
            MaterialButton(
                onPressed: () {
                  context
                      .read<OrdersBloc>()
                      .add(OrdersOnSendProductsToFireStoreEvent(list));
                },
                color: Theme.of(context).colorScheme.secondaryContainer,
                minWidth: fillMaxWidth(context),
                height: 45.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2.0,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: TextView(
                  text: 'Buyurtma berish',
                  textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  maxLines: 1,
                  textSize: 18.0,
                ))
          ],
        ),
      ),
    );
  }

  Widget _ordersRowCardItem({
    required String name,
    required String count,
    required String price,
  }) =>
      Container(
        width: fillMaxWidth(context),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextView(
              text: name,
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 14.0,
              weight: FontWeight.w500,
            ),
            const SizedBox(width: 4.0),
            TextView(
              text: '${count}x',
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 16.0,
            ),
            const SizedBox(width: 10.0),
            TextView(
              text: price,
              textColor: Theme.of(context).colorScheme.onSecondary,
              maxLines: 1,
              textSize: 14.0,
              weight: FontWeight.w700,
            ),
          ],
        ),
      );

  Widget _cartIsEmptyAnim() => Center(
          child: Lottie.asset(
        lottieFilePath,
        width: 300.0,
        height: 300.0,
      ));
}
