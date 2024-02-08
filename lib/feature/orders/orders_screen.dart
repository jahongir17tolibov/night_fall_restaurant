// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:night_fall_restaurant/domain/model/order_products_model.dart';
import 'package:night_fall_restaurant/feature/home/home_screen.dart';
import 'package:night_fall_restaurant/feature/orders/bloc/orders_bloc.dart';
import 'package:night_fall_restaurant/feature/orders/widget/order_product_price_card.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/cached_image_view.dart';
import 'package:night_fall_restaurant/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

class OrdersScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/orders";

  const OrdersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OrdersScreenState();

  static void open(BuildContext context) {
    Navigator.of(context).pushNamed(ROUTE_NAME);
  }
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late int _totalPrice;
  static const String lottieFilePath = 'assets/anim/cart_is_empty_lottie.json';

  @override
  Widget build(BuildContext context) {
    _totalPrice = context.watch<OrdersBloc>().calculatePrices;
    return WillPopScope(
      child: Scaffold(
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 4.0,
                        ),
                        scrollDirection: Axis.vertical,
                        physics: Platform.isIOS
                            ? const BouncingScrollPhysics()
                            : const BouncingScrollPhysics(),
                        itemCount: state.ordersList.length,
                        itemBuilder: (context, index) {
                          final item = state.ordersList[index];
                          return _ordersItem(orderProduct: item);
                        },
                      ),
                    ),
                    OrderProductPriceCard(
                      orderProductsList: state.ordersList,
                      totalPrice: _totalPrice,
                    ),
                  ],
                );

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
              HomeScreen.close(context);
            }
            if (state is OrdersShowSnackMessageActionState) {
              showSnackBar(state.message, context);
            }
            if (state is OrdersShowSuccessfullySentActionState) {
              _showWhenSentDialog(state.lottiePath, state.statusText);
            }
          },
        ),
      ),
      onWillPop: () async {
        context.read<OrdersBloc>().add(OrdersOnNavigateBackEvent());
        return false;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _portraitModeOnly();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    context.read<OrdersBloc>().add(OrdersOnGetProductsEvent());
  }

  @override
  void dispose() {
    _enableRotation();
    _animationController.dispose();
    super.dispose();
  }

  void _showWhenSentDialog(String lottiePath, String status) {
    showAdaptiveDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
        elevation: 4.0,
        content: SizedBox(
          width: fillMaxWidth(context),
          height: fillMaxHeight(context) * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                lottiePath,
                width: 260.0,
                height: 260.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18.0,
                    fontFamily: 'Ktwod',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// orders list side
  Widget _ordersItem({required OrderProductsModel orderProduct}) {
    /// add or remove products widget
    Widget amountProductsWidget = Container(
      width: fillMaxWidth(context) * 0.26,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
        borderRadius: BorderRadius.circular(fillMaxWidth(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// remove button
          IconButton(
            onPressed: () {
              context
                  .read<OrdersBloc>()
                  .add(OrderDecreaseProductEvent(orderProduct));
            },
            icon: Icon(
              Icons.remove_rounded,
              size: 16.0,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),

          /// value state text
          Center(
            child: TextView(
              text: "${orderProduct.quantity}",
              textColor: Theme.of(context).colorScheme.onBackground,
              textSize: 14.0,
              weight: FontWeight.w500,
              maxLines: 1,
            ),
          ),

          /// add button
          IconButton(
            onPressed: () {
              context
                  .read<OrdersBloc>()
                  .add(OrderIncreaseProductEvent(orderProduct));
            },
            icon: Icon(
              Icons.add_rounded,
              size: 16.0,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );

    /// imageView
    Widget productsImage = CachedImageView(
      imageUrl: orderProduct.image,
      width: fillMaxWidth(context) * 0.175,
      height: fillMaxHeight(context) * 0.2,
      controller: _animationController,
      borderRadius: 14.0,
    );

    /// list tile
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: productsImage,
        trailing: amountProductsWidget,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: TextView(
          text: orderProduct.name,
          textColor: Theme.of(context).colorScheme.onSurface,
          textSize: 22.0,
          maxLines: 1,
          weight: FontWeight.w500,
        ),
        subtitle: TextView(
          text: orderProduct.price,
          textColor: Theme.of(context).colorScheme.onSurface,
          textSize: 12.5,
          maxLines: 1,
        ),
      ),
    );
  }

  /// send orders side
  Widget _orderProductPriceCard({required List<OrderProductsModel> list}) =>
      Card(
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(12.0),
        elevation: 6.0,
        child: Container(
          width: fillMaxWidth(context),
          height: fillMaxHeight(context) * 0.25,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                        "${NumberFormat.decimalPatternDigits().format(_totalPrice)} so`m",
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
                  height: fillMaxHeight(context) * 0.05,
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
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    maxLines: 1,
                    textSize: 18.0,
                  ))
            ],
          ),
        ),
      );

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
              text:
                  "${int.parse(price.replaceAll('so`m', '').replaceAll(' ', '')) * int.parse(count)}so`m",
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

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
